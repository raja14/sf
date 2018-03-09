/**
 * Created by rvivek on 3/3/2018.
 */
({
    doInit : function (component, event, helper) {
      helper.onSearch(component,event);
    },
    doSearch : function (component, event, helper) {
        var params = event.getParam('arguments');
        var formData = params.boatTypeId;
        console.log(formData);
        component.set("v.boatTypeId",formData);
        helper.onSearch(component,event);
    },
    onBoatSelect : function (component, event, helper) {
        var boatId = event.getParam('boatId');
        component.set("v.selectedBoatId",boatId);

    }
})