public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        AddRows();
    }

    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(PickListEntry eachPicklistValue : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(eachPicklistValue.getValue(), eachPicklistValue.getLabel()));
        }
        return options;
    }

    public void AddRows(){
        for (Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add(new ProductWrapper());
        }
    }

    @AuraEnabled 
    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public PageReference Save(){ 
        Savepoint sp = Database.setSavepoint();
        try {
            List<Product2> products = new List<Product2>();
            List<PricebookEntry> entries = new List<PricebookEntry>();

            for (ProductWrapper productWrap : productsToInsert){
                if(null!=productWrap.productRecord && null!=productWrap.pricebookEntryRecord){

                    if(null!=productWrap.productRecord.Name && null!=productWrap.productRecord.Family && constants.SELECT_ONE!=productWrap.productRecord.Family
                            && null!=productWrap.productRecord.Initial_Inventory__c && null!=productWrap.pricebookEntryRecord.UnitPrice){
                        products.add(productWrap.productRecord);
                        PricebookEntry entry=productWrap.pricebookEntryRecord;
                        entry.IsActive=true;
                        entry.Pricebook2Id=constants.STANDARD_PRICEBOOK_ID;
                        entries.add(entry);
                    }
                }
            }

            insert products;

            for (integer itr=0; itr<entries.size();itr++){
                entries[itr].Product2Id=products[itr].id;
            }
            insert entries;
            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,constants.ERROR_MESSAGE));
        }
        return null;
    }

    public class ProductWrapper {
        public Product2 productRecord  {get;set;}
        public PriceBookEntry pricebookEntryRecord {get;set;}

        public ProductWrapper() {
            productRecord = new Product2();
            pricebookEntryRecord = new PricebookEntry();
        }
    }

}