/**
 * Created by rvivek on 2/26/2018.
 */
({
    createItem : function (component, event) {
        var addItemEvent = component.getEvent("addItem");
        addItemEvent.setParams({"item": component.get("v.newItem")});
        addItemEvent.fire();

        var resetNewItem = "{'sobjectType' : 'Camping_Item__c','Quantity__c':'0','price':'0'}";
        component.set("v.newItem",resetNewItem);
    }
})