@isTest
private class ProjectRESTServiceTest {
  static testMethod void testBehavior() {
    RestRequest request = new RestRequest();
    request.requestUri =
            '/project/*';
    request.httpMethod = 'POST';
    RestContext.request = request;
    // Call the method to test

    Opportunity opportunity = new Opportunity(Name='test opportunity',type='New Project',Amount=10000,CloseDate=Date.Today(),StageName='Submitted Project');
    insert opportunity;

    Project__c project = new Project__c(ProjectRef__c = 'newProjectRef',Name='firstProject',Opportunity__c=opportunity.Id,Start_Date__c=Date.today(),End_Date__c=Date.today().addDays(7),Billable_Amount__c=100000,Status__c='Billable');

    insert project;

    String result = ProjectRESTService.postProjectData('newProjectRef','secondProject',opportunity.Id,Date.today(),Date.today().addDays(14),5000000,'Billable');
    system.assertEquals('OK',result);


  }

  static testMethod void testBehavior2() {
    RestRequest request = new RestRequest();
    request.requestUri =
            '/project/*';
    request.httpMethod = 'POST';
    RestContext.request = request;
    // Call the method to test

    Opportunity opportunity = new Opportunity(Name='test opportunity',type='New Project',Amount=10000,CloseDate=Date.Today(),StageName='Submitted Project');
    insert opportunity;

    Project__c project = new Project__c(ProjectRef__c = 'newProjectRef',Name='firstProject',Opportunity__c=opportunity.Id,Start_Date__c=Date.today(),End_Date__c=Date.today().addDays(7),Billable_Amount__c=100000,Status__c='Billable');

    insert project;

    String result = ProjectRESTService.postProjectData('newProjectRef1','secondProject',opportunity.Id,Date.today(),Date.today().addDays(14),5000000,'Billable1');
    system.debug('----'+result);
    system.assert(result.startsWith('Upsert failed.')); 


  }

  }