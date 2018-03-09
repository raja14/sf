global class WarehouseSyncSchedule implements Schedulable{
  public static String CRON_EXP = '0 1 * * *';
  // implement scheduled code here

  global void execute(SchedulableContext ctx) {
    WarehouseCalloutService.runWarehouseEquipmentSync(); 
  }
}