/**
 * Created by syurks on 2/9/2018.
 */

@IsTest
private class TestRestrictContactByName {
    static testMethod void testBehavior() {
        Contact contact = new Contact(LastName='INVALIDNAME');
        Contact contact2 = new Contact(LastName='raja');
        List<Contact> contacts = new List<Contact>();
        contacts.add(contact);
        contacts.add(contact2);
        Test.startTest();
        List<Database.SaveResult> results = Database.insert(contacts, false);

        for (Database.SaveResult saveResult : results) {
            if(saveResult.isSuccess()){
                Contact contact3 = [Select LastName from Contact where Id=:saveResult.getId()];
                System.assertNotEquals(contact3.LastName,'INVALIDNAME');
            }else{
                System.assertEquals(saveResult.getErrors()[0].getMessage().contains('INVALIDNAME'),true);
            }
        }

        Test.stopTest();

    }
}