public without sharing class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(Map<Id, Order> newOrdersByIds, Map<Id, Order> oldOrdersByIds) {

        Set<Id> activatedOrders = new Set<Id>();
        for (Order order : newOrdersByIds.values()) {
            if (Constants.ACTIVATED_ORDER_STATUS.equals(order.Status) && Constants.DRAFT_ORDER_STATUS.equals(oldOrdersByIds.get(order.Id).Status)) {
                activatedOrders.add(order.Id);
            }
        }
        RollUpOrderItems(activatedOrders);

    }



    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds) {


        Savepoint sp;
        try {

            AggregateResult[] aggregateResults = [
                    SELECT
                            Product2Id,
                            sum(Quantity) totalQty
                    FROM OrderItem where OrderId=:activatedOrderIds
                    group by Product2Id
            ];

            Set<Id> productIdSet = new Set<Id>();
            Map<Id,Decimal> productIdQtyMap = new Map<Id,Decimal>();

            for (AggregateResult ar : aggregateResults){
                String productId = (String)ar.get('Product2Id');
                Decimal totalQty = (Decimal)ar.get('totalQty');
                productIdSet.add(productId);
                productIdQtyMap.put(productId,totalQty);
            }

            Map<Id, Product2> productMap = new Map<Id,Product2>([Select Id,Quantity_Ordered__c,Current_Inventory__c from Product2 where Id=:productIdSet ]);

            for (Id prId : productMap.keySet()) {
                Product2 product = productMap.get(prId) ;
                Decimal quantityOrdered = product.Quantity_Ordered__c==null? productIdQtyMap.get(prId): product.Quantity_Ordered__c + productIdQtyMap.get(prId);
                Decimal currentInventory =
                        product.Current_Inventory__c==null? productIdQtyMap.get(prId): product.Current_Inventory__c + productIdQtyMap.get(prId);

                product.Quantity_Ordered__c = quantityOrdered;
                product.Current_Inventory__c = currentInventory;
            }
            sp = database.setsavepoint();
            update productMap.values();
        }catch (Exception e) {
            database.rollback(sp);
            throw(e); 
        }

//ToDo: Declare a Map named "productMap" of Ids to Product2 records

//ToDo: Loop through a query of OrderItems related to the activatedOrderIds

//ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value

//ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset

//ToDo: Perform an update on the records in the productMap
    }


}