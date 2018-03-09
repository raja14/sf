/**
 * Created by rvivek on 3/4/2018.
 */
({
    doInit : function (component, event, helper) {
        helper.onInit(component,event);
    },
    onUserInfoClick : function(component,event,helper) {
        var userId = event.currentTarget.getAttribute("data-userid");
        var navigateToSObject = $A.get("e.force:navigateToSObject");
        navigateToSObject.setParams({
            "recordId": userId,
        });
        navigateToSObject.fire();
    },
    refresh: function (component, event, helper) {
        helper.onInit(component,event);
    }
})