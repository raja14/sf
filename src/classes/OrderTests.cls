@isTest
private class OrderTests {

    @TestSetup
    static void SetupTestData() {
        PriceBook2 pb = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
        update pb;
        TestDataFactory.InsertTestData(10);
    }

    static testMethod void OrderUpdate_UnitTest() {
        List<Order> ordersList = [
                SELECT
                        Status, (
                        SELECT
                                Id,Pricebookentry.Product2.Quantity_Ordered__c,Pricebookentry.Product2Id
                        FROM OrderItems
                )
                FROM Order
        ];
        Map<Id, Product2> originalProduct2Map = new Map<Id, Product2>();
        for (Order ord : ordersList) {
            ord.Status = Constants.ACTIVATED_ORDER_STATUS;
            for (OrderItem ordItem : ord.OrderItems) {
                Product2 originalProduct = new Product2(Id = ordItem.Pricebookentry.Product2Id, Quantity_Ordered__c = ordItem.Pricebookentry.Product2 .Quantity_Ordered__c);
                originalProduct2Map.put(originalProduct.Id, originalProduct);
            }
        }
        update ordersList;

        List<Order> orders = [
                SELECT
                        Status, (
                        SELECT
                                Id,Pricebookentry.Product2.Quantity_Ordered__c,Pricebookentry.Product2Id
                        FROM OrderItems
                )
                FROM Order
        ];
        Map<Id, Product2> updatedProduct2Map = new Map<Id, Product2>();
        for (Order order : orders) {
            for (OrderItem orderItem : order.OrderItems) {
                Product2 originalProduct = new Product2(Id = orderItem.Pricebookentry.Product2Id, Quantity_Ordered__c = orderItem.Pricebookentry.Product2.Quantity_Ordered__c);
                updatedProduct2Map.put(originalProduct.Id, originalProduct);
            }
        }

        for (Id id : originalProduct2Map.keySet()) {
            TestDataFactory.VerifyQuantityOrdered(originalProduct2Map.get(id), updatedProduct2Map.get(id), 5);
        }

    }

    @isTest static void OrderExtension_UnitTest() {
        PageReference pageRef = Page.OrderEdit;
        Test.setCurrentPage(pageRef);
//        SetupTestData();
        Order ord = [
                SELECT
                        Id,
                        Status
                FROM Order
                limit 1
        ];
        pageRef.getParameters().put('id', ord.id);
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(ord);
        PriceBook2 pb = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
        update pb;
        OrderExtension orderExtension = new OrderExtension(stdcontroller);
//        System.assertEquals(Constants.DEFAULT_ROWS, orderExtension.orderItemList.size());
        orderExtension.OnFieldChange();
        orderExtension.SelectFamily();
        orderExtension.Save();
        orderExtension.First();
        orderExtension.Next();
        orderExtension.Previous();
        orderExtension.Last();
        orderExtension.GetHasPrevious();
        orderExtension.GetHasNext();
        orderExtension.GetTotalPages();
        orderExtension.GetPageNumber();
        orderExtension.GetFamilyOptions();
        ChartHelper.GetInventory();

    }


}

