/**
 * Created by syurks on 2/12/2018.
 */

@IsTest
private class WarehouseSyncScheduleTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testMethod void testBehavior() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
                CRON_EXP,
                new WarehouseSyncSchedule());
        Test.stopTest();
    }

    static testMethod void testBehavior1() {
        WarehouseCalloutServiceMock.validMockData = '12345';
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
                CRON_EXP,
                new WarehouseSyncSchedule());
        Test.stopTest();
    }
}