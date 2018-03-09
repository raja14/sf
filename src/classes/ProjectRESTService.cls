@RestResource(urlMapping='/project/*')
global with sharing class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Decimal Amount, String Status){
        system.debug('project data posted ==>'+projectRef);
        Savepoint sp = null;
        List<Project__c> projects = [SELECT Billable_Amount__c,End_Date__c,Id,Name,Opportunity__c,ProjectRef__c,Start_Date__c,Status__c FROM Project__c WHERE ProjectRef__c = :ProjectRef];
        Project__c project = new Project__c(ProjectRef__c = ProjectRef,Name=ProjectName,Opportunity__c=OpportunityId,Start_Date__c=StartDate,End_Date__c=EndDate,Billable_Amount__c=Amount,Status__c=Status);
        if(projects.size() > 0)
            project.Id  = projects.get(0).Id;


        try{
            sp = Database.setSavepoint();
            upsert project;

            Opportunity opportunity = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :OpportunityId];
            opportunity.DeliveryInstallationStatus__c = 'In progress';
            update opportunity;

            return 'OK';
        }
        catch(exception ex){
            Database.rollback(sp);
            return ex.getMessage();
        }
    }
}