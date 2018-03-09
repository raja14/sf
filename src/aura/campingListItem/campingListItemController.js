/**
 * Created by syurks on 2/26/2018.
 */
({
    packItem : function(component,event,helper){
        var item = component.get("v.item");
        item.packed__c=true;
        component.set("v.item",item);
        event.currentTarget.disabled = true;
    }
})