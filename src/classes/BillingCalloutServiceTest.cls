@isTest
private class BillingCalloutServiceTest {
  @testSetup
  static void setup(){
    Opportunity opportunity = new Opportunity(Name='NewProspect',CloseDate=Date.today(),StageName='Prospecting');
    insert opportunity;

    Project__c project = new Project__c(Name='NewProject',Billable_Amount__c=10000,ProjectRef__c='NewProject',
            Status__c='Running',Opportunity__c= opportunity.Id);
    insert project;

    ServiceCredentials__c servCred = new ServiceCredentials__c();
    servCred.Name = 'BillingServiceCredential';
    servCred.Username__c = 'user1';
    servCred.Password__c = 'pass1';
    insert servCred;
  }

  //Implement mock callout tests here
  static testMethod void testBehavior() {
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
    List<Project__c> projectList = [SELECT Status__C FROM Project__c WHERE ProjectRef__c = 'NewProject'];
    Test.startTest();
    projectList[0].Status__c = 'Billable';
    update projectList;
    Test.stopTest();
    projectList = [SELECT Status__C FROM Project__c WHERE ProjectRef__c = 'NewProject'];
    System.assertEquals(1, projectList.size());
    System.assertEquals('Billed', projectList[0].Status__C);
  }

  //Implement mock callout tests here
  static testMethod void testBehavior2() {
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
    List<Project__c> projectList = [SELECT Status__C FROM Project__c WHERE ProjectRef__c = 'NewProject'];
    Test.startTest();
    projectList[0].Status__c = 'Running';
    update projectList;
    Test.stopTest();
    projectList = [SELECT Status__C FROM Project__c WHERE ProjectRef__c = 'NewProject']; 
    System.assertEquals(1, projectList.size());
    System.assertEquals('Running', projectList[0].Status__C);
  }

}