/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

    public Order orderRecord { get; set; }
    public List<OrderItem> orderItemList { get; set; }
    public String selectedFamily { get; set; }
    public List<chartHelper.chartData> pieData { get; set; }
    public Decimal total { get; set; }

    public Map<Id, OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;

    public OrderExtension(ApexPages.StandardController standardController) {
        orderRecord = (Order) standardController.getRecord();
        orderItemMap = new Map<id, OrderItem>();
        if (orderRecord.Id != null) {
            orderRecord = queryOrderRecord(orderRecord.Id);
        }

        refreshController();

        total = 0;

        for (OrderItem orderItem : orderRecord.OrderItems){
            orderItemMap.put(orderItem.Product2Id, orderItem);
            if(orderItem.Quantity > 0){
                if(null == pieData){
                    pieData = new List<ChartHelper.ChartData>();
                }
                pieData.add(new chartHelper.ChartData(orderItem.Product2.Name, orderItem.Quantity * orderItem.UnitPrice));
                total += orderItem.UnitPrice * orderItem.Quantity;
            }
        }
        populateOrderItemList();
    }

    public void refreshController(){
        String query =
                'SELECT Name, Pricebook2Id, Product2Id, ProductCode, UnitPrice,' +
                        ' UseStandardPrice,Product2.Family, Product2.Name, Product2.Quantity_Remaining__c FROM PricebookEntry WHERE IsActive = TRUE';

        if(selectedFamily != null && selectedFamily != Constants.SELECT_ONE){
            query += ' AND Product2.Family = \'' + selectedFamily + '\'';
        }
        query += ' ORDER BY Name';

        standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        standardSetController.setPageSize(Constants.DEFAULT_ROWS);
    }

    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection

    public void populateOrderItemList() {
        orderItemList = new List<OrderItem>();
        for (SObject sobj : standardSetController.getRecords()) {
            PricebookEntry pricebookEntry = (PricebookEntry) sobj;

            if (orderItemMap.containsKey(pricebookEntry.Product2Id)) {
                orderItemList.add(orderItemMap.get(pricebookEntry.Product2Id));
            } else {
                OrderItem orderItem = new OrderItem(
                        PricebookEntryId = pricebookEntry.Id,
                        Product2Id = pricebookEntry.Product2Id,
                        UnitPrice = pricebookEntry.UnitPrice,
                        Quantity = 0,
                        Product2 = pricebookEntry.Product2
                );
                orderItemList.add(orderItem);
                orderItemMap.put(pricebookEntry.Product2Id, orderItem);
            }
        }
    }


    /**
     * @name OnFieldChange
     * @description
    **/
    public void OnFieldChange() {
        //ToDo: Implement logic to store the values changed on the page
        //      and populate pieData
        //      and populate total

        for (OrderItem orderItem : orderItemList){
            orderItemMap.put(orderItem.Product2Id, orderItem);
        }

        pieData = null;
        total = 0;
        for (OrderItem orderItem : orderItemMap.values()){
            if(orderItem.Quantity > 0){
                if(null == pieData){
                    pieData = new List<chartHelper.ChartData>();
                }
                pieData.add(new chartHelper.ChartData(orderItem.Product2.Name, orderItem.Quantity * orderItem.UnitPrice));
                //      and populate total
                total += orderItem.UnitPrice * orderItem.Quantity;
            }

        }

    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily() {
        //ToDo: Implement logic to filter based on the selected product family
        refreshController();
        populateOrderItemList();
    }

    /**
     * @name Save
     * @description
    **/
    public void Save() {
        //ToDo: Implement logic to save the Order and populated OrderItems

        System.Savepoint sp = Database.setSavepoint();
        try {
            if (null == orderRecord.Pricebook2Id) {
                orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }
            upsert orderRecord;

            List<OrderItem> orderItemsToUpsert = new List<OrderItem>();
            List<OrderItem> orderItemsToDelete = new List<OrderItem>();
            for (OrderItem oi : orderItemMap.values()) {
                if (oi.Quantity > 0) {
                    if (null == oi.OrderId) {
                        oi.OrderId = orderRecord.Id;
                    }
                    orderItemsToUpsert.add(oi);
                } else if (oi.Id != null) {
                    orderItemsToDelete.add(new OrderItem(id = oi.Id));
                    oi.id = null;
                }
            }
            upsert orderItemsToUpsert;
            delete orderItemsToDelete;
        } catch (Exception e) {
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, Constants.ERROR_MESSAGE));
        }

    }


    /**
     * @name First
     * @description
    **/
    public void First() {
        standardSetController.first();
        populateOrderItemList();
    }


    /**
     * @name Next
     * @description
    **/
    public void Next() {
        standardSetController.next();
        populateOrderItemList();
    }


    /**
     * @name Previous
     * @description
    **/
    public void Previous() {
        standardSetController.previous();
        populateOrderItemList();
    }

    /**
     * @name Last
     * @description
    **/
    public void Last() {
        standardSetController.last();
        populateOrderItemList();
    }

    /**
     * @name GetHasPrevious
     * @description
    **/
    public Boolean GetHasPrevious() {
        return standardSetController.getHasPrevious();
    }

    /**
     * @name GetHasNext
     * @description
    **/
    public Boolean GetHasNext() {
        return standardSetController.getHasNext();
    }

    /**
     * @name GetTotalPages
     * @description
    **/
    public Integer GetTotalPages() {
        return (Integer)Math.ceil(standardSetController.getResultSize() / (Decimal)Constants.DEFAULT_ROWS);
    }

    /**
     * @name GetPageNumber
     * @description
    **/
    public Integer GetPageNumber() {
        return standardSetController.getPageNumber();
    }

    /**
     * @name GetFamilyOptions
     * @description
    **/
    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> selectOptions = new List<SelectOption>();
        selectOptions.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(Schema.Picklistentry picklistEntry : Constants.PRODUCT_FAMILY){
            selectOptions.add(new SelectOption(picklistEntry.getValue(), picklistEntry.getLabel()));
        }
        return selectOptions;
    }

    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order QueryOrderRecord(Id orderId) {
        return [
                SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id, (
                        SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
                                Product2.Name, Product2.Family, Product2.Quantity_Remaining__c
                        FROM OrderItems
                )
                FROM Order
                WHERE Id = :orderId
        ];
    }

}