/**
 * Created by syurks on 2/12/2018.
 */

@IsTest
private class MaintenanceRequestHelperTest {

    @TestSetup
    static void setup(){


    }

    static testMethod void testBehavior() { 
        Account account = new Account(Name='raja-NY',BillingState ='NY');
        insert account;
        Vehicle__c vehicle = new Vehicle__c(Air_Conditioner__c=true,Awning__c='Manual',Backup_Camera_Monitor__c=true,Bathroom_Hookup__c='Walk-In Shower',Bathrooms__c=2,Bedrooms__c=2);
        insert vehicle;

        Product2 product2 = new Product2(ProductCode='GC1040',Description='test data',Family='',Name='GenWatt Diesel 200kW',Cost__c=100,Current_Inventory__c=5,Lifespan_Months__c=2,Maintenance_Cycle__c=100,Replacement_Part__c=true,Warehouse_SKU__c='100099');

        insert product2;

        Case newCase = new Case(Type='Routine Maintenance',AccountId=account.Id,Vehicle__c = vehicle.Id,Equipment__c=product2.Id );

        insert newCase;

        newCase.status='Closed';

        update newCase;

        List<Case> futureCase = [Select Id,Status from Case where type=:newCase.Type and AccountId=:newCase.AccountId ];

        system.assert(futureCase.size()>0);
    }
}