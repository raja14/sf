/**
 * Created by rvivek on 3/3/2018.
 */

public with sharing class BoatSearchResults {

    @AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId ){
        system.debug('calling searchBaots '+boatTypeId );
        List<Boat__c> boatsList = null;
        if(String.isBlank(boatTypeId )){
            boatsList = [
                    SELECT
                            BoatType__r.name,
                            Contact__r.name,
                            Description__c,
                            Id,
                            Length__c,
                            Name,
                            Picture__c,
                            Geolocation__Latitude__s,
                            Geolocation__Longitude__s,
                            Price__c,
                            SystemModstamp,
                            Year_Built__c
                    FROM Boat__c];
        }else
        boatsList = [
                SELECT
                        BoatType__r.name,
                        Contact__r.name,
                        Description__c,
                        Id,
                        Length__c,
                        Name,
                        Geolocation__Latitude__s,
                        Geolocation__Longitude__s,
                        Picture__c,
                        Price__c,
                        SystemModstamp,
                        Year_Built__c
                FROM Boat__c where BoatType__c=:boatTypeId ];

        system.debug('return list ---');
        system.debug(boatsList);

        return boatsList;
    }

}