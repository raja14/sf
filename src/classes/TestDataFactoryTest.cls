/**
 * Created by syurks on 3/8/2018.
 */

@IsTest
private class TestDataFactoryTest {
    @IsTest(SeeAllData=true)
    static void testBehavior() {
        List<Product2> product2s = TestDataFactory.ConstructProducts(10);

        for (Product2 product2 : product2s) {
            system.debug(product2);
        }

    }

    @IsTest(SeeAllData=true)
    static void testBehavior2(){
        List<Account> accounts = TestDataFactory.ConstructAccounts(10);

        insert accounts;

        List<Order> orders = TestDataFactory.ConstructOrders(10, accounts);
        insert orders ;

        List<Product2> product2s = TestDataFactory.ConstructProducts(10);
        insert product2s;

        List<PriceBookEntry> pricebookentries = TestDataFactory.ConstructPricebookEntries(product2s);
        insert pricebookentries;

        List<OrderItem> orderItems =TestDataFactory.ConstructOrderItems(10, pricebookentries, orders);
        insert orderItems;

        system.debug('orderItem----->'+orderItems.size());
        system.debug('orders----->'+orders.size());
        system.debug('pricebookentries----->'+pricebookentries.size()); 
        for (OrderItem orderItem : orderItems) {
            system.debug('orderItem----->');
            system.debug(orderItem);
        }
    }
}