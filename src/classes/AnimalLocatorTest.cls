/**
 * Created by rvivek on 2/10/2018.
 */

@IsTest
private class AnimalLocatorTest {
    static testMethod void testBehavior() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        String actualValue = AnimalLocator.getAnimalNameById(1);
        String expectedValue = 'chicken'; 
        System.assertEquals(actualValue, expectedValue);
    }
}