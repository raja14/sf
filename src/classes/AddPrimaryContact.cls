/**
 * Created by rvivek on 2/10/2018.
 */

public with sharing class AddPrimaryContact implements Queueable{
    Contact contact;
    String state;

    public AddPrimaryContact(Contact contact,String state){
        this.contact=contact;
        this.state=state;
    }

    public void execute(QueueableContext context){
        Map<Id,Account> accountMap = new Map<Id,Account>([Select id,BillingState from Account where BillingState =:state limit 200]); 
        List<Contact> contacts = new List<Contact>();
        for (Id id : accountMap.keySet()) {
            Contact newContact = contact.clone();
            newContact.AccountId=id;
            contacts.add(newContact);
        }
        insert contacts;
    }

}