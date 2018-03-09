/**
 * Created by rvivek on 2/11/2018.
 */

public with sharing class ParkLocator {

    public static String[] country(String country){
        ParkService.ParksImplPort parkService = new ParkService.ParksImplPort();
        system.debug('parkservice-->'+parkService);
        return parkService.byCountry(country);
    }

}