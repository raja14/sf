/**
 * Created by rvivek on 2/10/2018.
 */

@IsTest
private class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @TestSetup
    static void setup(){
        List<Lead> leads = new List<Lead>();
        for(Integer i = 0;i<200;i++){
            Lead lead = new Lead(LastName='vivek',Company='company'); 
            leads.add(lead);
        }
        insert leads;
    }

    static testMethod void testBehavior() {
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
                CRON_EXP,
                new DailyLeadProcessor());
        Test.stopTest();
        System.assertEquals(200,[Select count() from Lead where LeadSource='Dreamforce']);

    }
}