/**
 * Created by syurks on 2/9/2018.
 */


public class RandomContactFactory {
    private static Integer randomIncrement = 0;
    public static List<Contact> generateRandomContacts(Integer numberOfContacts,String lastName){
        List<Contact> generatedContacts = new List<Contact>();

        if(numberOfContacts<1) return generatedContacts;

        for (Integer i = 0;i<numberOfContacts;i++) {
            generatedContacts.add(new Contact(FirstName='raja'+randomIncrement,LastName=lastName));
            randomIncrement++;
        }

        return generatedContacts; 
    }
}