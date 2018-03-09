/**
 * Created by rvivek on 3/4/2018.
 */

public with sharing class BoatReviews {

    @AuraEnabled
    public static List<BoatReview__c> getAll(){ 
        return [
                SELECT
                        Boat__c,
                        Comment__c,
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        Rating__c,
                        SystemModstamp,
                        CreatedBy.Name,
                        CreatedBy.SmallPhotoUrl,
                        CreatedBy.CompanyName
                FROM BoatReview__c];
    }

}