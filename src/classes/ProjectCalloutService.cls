public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
	public static void postOpportunityToPMS(List<Id> opportunityIds){
        List<Opportunity> opportunities = [Select Id,Name,Account.Name,CloseDate,Amount from Opportunity where id=:opportunityIds];
        PMSOpportunity opportunity = new PMSOpportunity();
        opportunity.opportunityId = opportunities[0].Id;
        opportunity.opportunityName = opportunities[0].Name;
        opportunity.accountName = opportunities[0].Account.Name;
        opportunity.CloseDate = opportunities[0].CloseDate;
        opportunity.amount = opportunities[0].amount;
        String JSONString = JSON.serialize(opportunity);
        System.enqueueJob(new QueueablePMSCall(JSONString,opportunityIds[0]));
    }

    class QueueablePMSCall implements Queueable, Database.AllowsCallouts{ 
        String jsonData;
        String opportunityId;
        public QueueablePMSCall(String jsonData,String oppId){
            this.jsonData = jsonData;
            this.opportunityId = oppId;
        }

        public void execute(QueueableContext context){
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:ProjectService');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setHeader('token',ServiceTokens__c.getValues('ProjectServiceToken').Token__c);
            req.setBody(jsonData);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            Opportunity opp = new Opportunity(Id=opportunityId);
            if(res.getStatusCode()==201){
                opp.StageName='Submitted Project';
            }else{
                opp.StageName = 'Resubmit Project';
            }
            update opp;
        }
    }

    class PMSOpportunity {
        String opportunityId {get;set;}
        String opportunityName {get;set;}
        String accountName {get;set;}
        Date closeDate {get;set;}
        Decimal amount {get;set;}
    }
}