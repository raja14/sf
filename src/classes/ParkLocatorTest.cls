/**
 * Created by rvivek on 2/11/2018.
 */

@IsTest
private class ParkLocatorTest {
    static testMethod void testBehavior() {
      Test.setMock(WebServiceMock.class,new ParkServiceMock());
        String[] values =  ParkLocator.country('United States'); 
        system.assert(values.size()>0);
    }
}