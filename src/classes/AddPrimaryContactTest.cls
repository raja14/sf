/**
 * Created by rvivek on 2/10/2018.
 */

@IsTest
private class AddPrimaryContactTest {

    @TestSetup
    static void setup(){
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<50;i++){
            Account account = new Account(Name='raja'+i+'NY',BillingState ='NY');
            Account account2 = new Account(Name='raja'+i+'CA',BillingState ='CA');
            accounts.add(account);
            accounts.add(account2);
        }
        insert accounts;
    }

    static testMethod void testBehavior() {
       Contact contact = new Contact(LastName='raja-contact');
        insert contact;
        Test.startTest();
        AddPrimaryContact addPrimaryContact = new AddPrimaryContact(contact,'NY');
       System.enqueueJob(addPrimaryContact);
        AddPrimaryContact addPrimaryContact1 = new AddPrimaryContact(contact,'CA');
        System.enqueueJob(addPrimaryContact1);
        Test.stopTest();
        System.assertEquals(50,[Select count() from Account where id in (Select AccountId from Contact) and BillingState ='NY']);
        System.assertEquals(50,[Select count() from Account where id in (Select AccountId from Contact) and BillingState ='CA']); 
    }
}