/**
 * Created by rvivek on 2/26/2018.
 */

public with sharing class CampingListController {
    @AuraEnabled
    public static List<Camping_Item__c> getItems() {
        return [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OwnerId,
                        Packed__c,
                        Price__c,
                        Quantity__c,
                        SystemModstamp
                FROM Camping_Item__c
        ];
    }

    @AuraEnabled
    public static Camping_Item__c saveItem(Camping_Item__c item) {
        upsert item;
        return item;
    }
}