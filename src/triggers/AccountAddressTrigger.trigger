/**
 * Created by rvivek on 2/9/2018.
 */

trigger AccountAddressTrigger on Account (before insert, before update) {
//    Map<Id,Account> samePostalCodeAccountsByIds = new Map<Id,Account>([Select Id,Match_Billing_Address__c,BillingPostalCode,ShippingPostalCode from Account where Match_Billing_Address__c=true ]);

    List<Account> samePostalCodeAccountsByIds = Trigger.new;

    for (Account account : samePostalCodeAccountsByIds) {
        if (account.Match_Billing_Address__c)
            account.ShippingPostalCode = account.BillingPostalCode;
    }
}