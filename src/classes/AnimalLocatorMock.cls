/**
 * Created by rvivek on 2/10/2018.
 */

@isTest
global class AnimalLocatorMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animal":{"id":1,"name":"chicken","eats":"chickenfood","says":"cluckcluck"}}');
        response.setStatusCode(200);
        return response;
    }
}