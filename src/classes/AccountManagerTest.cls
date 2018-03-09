/**
 * Created by rvivek on 2/11/2018.
 */

@IsTest
private class AccountManagerTest {
    static testMethod void testBehavior() {
     Account account = new Account(Name='raja');
        insert account;
        Contact contact = new Contact(LastName='raja-contact',AccountId=account.Id);
        Contact contact1 = new Contact(LastName='raja-contact1',AccountId=account.Id);

        insert contact;
        insert contact1;

        RestRequest request = new RestRequest();
        request.requestUri =
                '/services/apexrest/Accounts/'+account.Id+'/contacts'; 
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        system.assertEquals(2,thisAccount.contacts.size());
    }
}