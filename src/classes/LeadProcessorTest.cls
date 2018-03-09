/**
 * Created by syurks on 2/9/2018.
 */

@IsTest
private class LeadProcessorTest {

    @testSetup
    static void setup(){
      List<Lead> leads = new List<Lead>();
      Integer batchSize = 200;

        for (Integer k=0;k<batchSize;k++ ) {
            leads.add(new Lead(LastName='raja'+k,Company='company'));
        }
        insert leads;

    }

    static testMethod void testBehavior() {
        Test.startTest();
        LeadProcessor leadProcessor = new LeadProcessor();
        Id batchId = Database.executeBatch(leadProcessor);
        Test.stopTest();

        System.assertEquals(200,[Select count() from Lead where LeadSource='Dreamforce']);

    }
}