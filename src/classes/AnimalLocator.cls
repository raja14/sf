/**
 * Created by rvivek on 2/10/2018.
 */

public class AnimalLocator {
    public static final String endPoint = 'https://th-apex-http-callout.herokuapp.com/animals/';
    public static String getAnimalNameById(Integer id) {
    Http http = new Http();
        HttpRequest request = new HttpRequest();
        String newEndPoint = endPoint+id;
        request.setEndpoint(newEndPoint);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

//        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            Object obj =  results.get('animal');
            Animal newAnimal = (Animal) JSON.deserialize(JSON.serialize(obj),Animal.class);
            return newAnimal.name;
//        }
    } 
}