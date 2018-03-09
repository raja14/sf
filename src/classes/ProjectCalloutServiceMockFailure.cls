global class ProjectCalloutServiceMockFailure implements HttpCalloutMock{
   //Implement http mock callout failure here
   global HTTPResponse respond(HttpRequest request){
      HttpResponse response = new HttpResponse();
      response.setStatusCode(500);
      response.setStatus('Server Error');
      return response;
   } 
}