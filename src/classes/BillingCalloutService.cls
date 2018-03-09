public class BillingCalloutService {
    //Implement business and callout logic methods here
    public static void callBillingService(List<Project__c> projectsUpdated,Map<Id,Project__c> oldProjectsByIds){
        if(!projectsUpdated.isEmpty()) {
            Project__c project = projectsUpdated[0];
            if(project.Status__c=='Billable' && oldProjectsByIds.get(project.Id).Status__c!='Billable') {
                runAsync(project.Billable_Amount__c,project.ProjectRef__c);
            }
        }
    }

    @Future(Callout=true)
    private static void runAsync(Decimal amount,String projectRef){ 
        ServiceCredentials__c serviceCredentials = ServiceCredentials__c.getInstance('BillingServiceCredential');
        BillingServiceProxy.project billingProject = new BillingServiceProxy.project();
        billingProject.billAmount = amount;
        billingProject.projectRef = projectRef;
        billingProject.username = serviceCredentials.Username__c;
        billingProject.password = serviceCredentials.Password__c;
        BillingServiceProxy.InvoicesPortSoap11 invoiceCall = new BillingServiceProxy.InvoicesPortSoap11();
        String response  = invoiceCall.billProject(billingProject);

        if(String.isNotBlank(response) && response.equalsIgnoreCase('OK')) {
            List<Project__c> projects =  [
                    Select Id, Status__c
                    From Project__c
                    Where ProjectRef__c = :projectRef
            ];
            if(!projects.isEmpty()) {
                projects[0].Status__c = 'Billed';
                update projects;
            }
        }
    }
}