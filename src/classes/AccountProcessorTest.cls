/**
 * Created by syurks on 2/9/2018.
 */

@IsTest
private class AccountProcessorTest {
    static testMethod void testBehavior() {
           Account myaAccount = new Account(Name='First');
           Account myaAccount1 = new Account(Name='Second');
           Account myaAccount2 = new Account(Name='Third');

        List<Account> allAccounts = new List<Account>();
        allAccounts.add(myaAccount);
        allAccounts.add(myaAccount1);
        allAccounts.add(myaAccount2);

        insert allAccounts;

        List<Id> accountIds = new List<Id>();

        for (Account account : allAccounts) {
            accountIds.add(account.Id);
        }

        List<Contact> contacts = RandomContactFactory.generateRandomContacts(10,'raja');

        for (integer i = 0;i<5;i++) {
            contacts[i].AccountId = myaAccount.Id;
        }
        for (integer i = 5;i<8;i++) {
            contacts[i].AccountId = myaAccount1.Id;
        }

        for (integer i = 8;i<10;i++) {
            contacts[i].AccountId = myaAccount2.Id;
        }

        insert contacts;

        Test.startTest();
        AccountProcessor.countContacts(accountIds);
        Test.stopTest();
        List<Account> accountsByIds = new List<Account>([Select Id,Name,Number_of_Contacts__c from Account ]);

        for (Account account : accountsByIds) {
            system.debug('account '+account.Name+' has '+account.Number_of_Contacts__c+' contacts');
            System.assert(account.Number_of_Contacts__c >0);
        }
    }
}