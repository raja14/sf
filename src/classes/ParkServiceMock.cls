/**
 * Created by rvivek on 2/11/2018.
 */

@IsTest
global class ParkServiceMock implements WebServiceMock{
    global void doInvoke(Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType){
        ParkService.byCountryResponse response_x = new ParkService.byCountryResponse() ;
        String[] parks = new String[]{'glendale','state'};
        response_x.return_x = parks;
        response.put('response_x',response_x);
    }
}