/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public  with sharing class TestDataFactory {

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
        system.debug('calling VerifyQuantityOrdered -->');
        Integer sumQ=Integer.valueOf(originalProduct.Quantity_Ordered__c) + qtyOrdered;

        System.assertEquals(sumQ,updatedProduct.Quantity_Ordered__c);
    }

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup collaborationGroup = new CollaborationGroup();
        collaborationGroup.Name = 'TEST'+Constants.INVENTORY_ANNOUNCEMENTS;
        collaborationGroup.CollaborationType='Public';
        return collaborationGroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        Integer prodFamilyCount = Constants.PRODUCT_FAMILY.size();
        Integer prodFamilyIndex = 0;
        List<Product2> product2sList = new List<Product2>();
        for (Integer i=0;i<cnt;i++) {
            Product2 product2 = new Product2 (Name='Food_1_'+Constants.PRODUCT_FAMILY[prodFamilyIndex].label,
                            Family=Constants.PRODUCT_FAMILY[prodFamilyIndex].label,Initial_Inventory__c=10,IsActive=true);
            if(prodFamilyCount == prodFamilyIndex+1)  prodFamilyIndex = 0;
            else prodFamilyIndex = prodFamilyIndex+1;
            product2sList.add(product2);
        }
        return product2sList;

    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PricebookEntry> pricebookentries = new List<PricebookEntry>();
        for (Product2 product2 : prods) {
            PricebookEntry pricebookentry = new PricebookEntry(isActive=true,Pricebook2Id=Constants.STANDARD_PRICEBOOK_ID,Product2Id=product2.Id,UnitPrice=10);
            pricebookentries.add(pricebookentry);
        }
        return pricebookentries;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.

        List<Account> accounts = new List<Account>();
        for (Integer i=0;i<cnt;i++) {
            Account account = new Account(Name='TEST_'+i);
            accounts.add(account);
        }
        return accounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.

//        if(cnt>accts.size()) cnt = accts.size();

        List<Contact> contacts = new List<Contact>();
        for (Integer i=0;i<cnt;i++) {
            Contact contact = new Contact(LastName='TEST_NAME_'+i,AccountId=accts[i].Id);
            contacts.add(contact);
        }

        return contacts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.

        List<Order> orders = new List<Order>();
//        if(cnt>accts.size()) cnt = accts.size();
        for (Integer i=0;i<cnt;i++) {
            Order order = new Order(AccountId=accts[i].Id,Status='Draft',Pricebook2Id=Constants.STANDARD_PRICEBOOK_ID,EffectiveDate=Date.TODAY());
            orders.add(order);
        }
        return orders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge

        List<OrderItem> orderItems = new List<OrderItem>();

        for (Integer i=0;i<cnt;i++) {
            OrderItem orderItem = new OrderItem(OrderId=ords[i].Id,PricebookEntryId=pbes[i].Id,UnitPrice=pbes[i].UnitPrice,Quantity=Constants.DEFAULT_ROWS );
            orderItems.add(orderItem);
        }

        return orderItems;

    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.

        CollaborationGroup collaborationGroup = ConstructCollaborationGroup();
        insert collaborationGroup;

        List<Account> accounts = ConstructAccounts(cnt);
        insert accounts;

        List<Contact> contacts = ConstructContacts(cnt, accounts);
        insert contacts;

        List<Product2> product2s = ConstructProducts(cnt);
        insert product2s;

        List<PriceBookEntry> pricebookentries = ConstructPricebookEntries(product2s);
        insert pricebookentries;

        List<Order> orders = ConstructOrders(cnt, accounts); 
        insert orders ;


        List<OrderItem> orderItems =ConstructOrderItems(cnt, pricebookentries, orders);
        insert orderItems;

    }

}