/**
 * Created by rvivek on 2/10/2018.
 */

global class DailyLeadProcessor implements Schedulable{
global void execute(SchedulableContext context){
    List<Lead> leads = [Select id,LeadSource from Lead where LeadSource=NULL or LeadSource='' limit 200];
    for (Lead lead : leads) {
        lead.LeadSource='Dreamforce'; 
    }
    update leads;
}
}