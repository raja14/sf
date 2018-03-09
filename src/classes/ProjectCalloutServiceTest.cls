@isTest
private class ProjectCalloutServiceTest {
  @testSetup
  static void setup(){
    ServiceTokens__c servToken = new ServiceTokens__c();
    servToken.Name = 'ProjectServiceToken';
    servToken.Token__c = '79f5c497-d1d7-4004-ba4c-79794a3c86ab';
    insert servToken;
  }
  //Implement Apex REST service tests here
  static testMethod void testBehavior() {
    Opportunity opportunity = new Opportunity(Name='test opportunity',type='New Project',Amount=10000,CloseDate=Date.Today(),StageName='Submitted Project');
    insert opportunity;
    List<Id> opportunityList = new List<Id>();
    opportunityList.add(opportunity.Id);

    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
    Test.startTest();
    ProjectCalloutService.postOpportunityToPMS(opportunityList);
    Test.stopTest();
    opportunity = [select StageName from Opportunity where id =: opportunity.Id];
    System.assertEquals('Submitted Project',opportunity.StageName);
  }

  //Implement Apex REST service tests here
  static testMethod void testBehavior2() {
    Opportunity opportunity = new Opportunity(Name='test opportunity',type='New Project',Amount=10000,CloseDate=Date.Today(),StageName='Submitted Project');
    insert opportunity;
    List<Id> opportunityList = new List<Id>();
    opportunityList.add(opportunity.Id);

    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
    Test.startTest();
    ProjectCalloutService.postOpportunityToPMS(opportunityList);
    Test.stopTest();
    opportunity = [select StageName from Opportunity where id =: opportunity.Id];
    System.assertEquals('Resubmit Project',opportunity.StageName);
  } 


}