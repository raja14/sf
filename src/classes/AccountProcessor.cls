/**
 * Created by syurks on 2/9/2018.
 */

public with sharing class AccountProcessor { 

    @future
    public static void countContacts(List<Id> accountIds){
        List<Account> accountsByIds = new List<Account>([Select Id,Number_of_Contacts__c,(Select id from contacts) from Account where Id = :accountIds]);

        for (Account account : accountsByIds) {
            account.Number_of_Contacts__c = account.Contacts.size();
        }

        update accountsByIds;
    }

}