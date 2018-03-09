/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (
        after update
) {


        List<Order> orders = Trigger.new;
        Map<Id,Order> newOrdersByIds = Trigger.newMap;
        Map<Id,Order> oldOrdersByIds = Trigger.oldMap;
        OrderHelper.afterUpdate(newOrdersByIds,oldOrdersByIds);
}