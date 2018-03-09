@isTest
private class WarehouseCalloutServiceTest {

    static testMethod void testBehavior() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
    }

    static testMethod void testBehaviorNegative() {
        WarehouseCalloutServiceMock.validMockData = '12345';
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest(); 
    }
}