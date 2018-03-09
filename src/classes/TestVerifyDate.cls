/**
 * Created by rvivek on 2/9/2018.
 */

@IsTest
private class TestVerifyDate {
    static testMethod void testBehavior() {
      Date date1 = Date.newInstance(2018,1,1);
      Date date2 = Date.newInstance(2018,1,31);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
        Date endOfMonth = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(VerifyDate.CheckDates(date1,date2),endOfMonth,'Not matching');
    }

    static testMethod void testBehavior2() {
        Date date1 = Date.newInstance(2018,1,1);
        Date date2 = Date.newInstance(2018,1,29);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
        Date endOfMonth = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(VerifyDate.CheckDates(date1,date2),date2,'Not matching');
    }

    static testMethod void testBehavior3() { 
        Date date2 = Date.newInstance(2018,1,1);
        Date date1 = Date.newInstance(2018,1,29);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
        Date endOfMonth = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(VerifyDate.CheckDates(date1,date2),endOfMonth,'Not matching');
    }
}