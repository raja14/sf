global with sharing class WarehouseCalloutService {

    class Equipment {
        public Decimal quantity {get;set;} 
        public String name {get;set;}
        public Decimal maintenanceperiod {get;set;}
        public Decimal lifespan {get;set;}
        public Decimal cost {get;set;}
        public String sku {get;set;}
    }

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
                readAndUpdateRecords();
    }

    public static void readAndUpdateRecords(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');

        List<Product2> product2s = new List<Product2>();

        HttpResponse response = http.send(request);
        try {
            List<Equipment> results = (List<Equipment>) JSON.deserialize(response.getBody(), List<Equipment>.class);
            system.debug('-------');
            for (Equipment syncedProduct2 : results) {
                Product2 prod = new Product2();
                prod.Replacement_Part__c = true;
                prod.Cost__c = syncedProduct2.cost;
                prod.Current_Inventory__c = syncedProduct2.quantity;
                prod.Lifespan_Months__c = syncedProduct2.lifespan;
                prod.Maintenance_Cycle__c = syncedProduct2.maintenanceperiod;
                prod.Warehouse_SKU__c = syncedProduct2.sku;
                prod.name = syncedProduct2.name;
                product2s.add(prod);
            }
            system.debug('-------');
            upsert product2s Product2.Fields.Warehouse_SKU__c;
        }catch(Exception ex){
            system.debug('unable to insert data with following error -->'+ex.getMessage());
        }
    }


}