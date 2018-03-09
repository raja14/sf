public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> updatedCases){
        List<Case> futureMaintenenCases = new List<Case>();
        List<Case> closedCased = [Select Id,Type,Status,Equipment__r.Maintenance_Cycle__c,Vehicle__c,Equipment__c  from Case where status ='Closed' and Type in ('Routine Maintenance','Repair ') and Id in :updatedCases];
        for (Case closedCase : closedCased) {
            Date futureDate = date.today();
            Date today = date.today();
            Date partsExpirationDate = today.addDays((Integer)closedCase.Equipment__r.Maintenance_Cycle__c);
//            if(futureDate>partsExpirationDate){
                futureDate = partsExpirationDate;
//            }
            Case futureMCase = new Case(Vehicle__c=closedCase.Vehicle__c,Type='Routine Maintenance',Subject='Routine Maintenance',Date_Reported__c=today ,Equipment__c=closedCase.Equipment__c,Date_Due__c=futureDate);
            futureMaintenenCases.add(futureMCase);
        }

        insert futureMaintenenCases;

    }        
    
}