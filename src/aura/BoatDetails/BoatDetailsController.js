/**
 * Created by rvivek on 3/3/2018.
 */
({
    handleActive: function (cmp, event, helper) {
        helper.lazyLoadTabs(cmp, event);
    },
    onBoatSelected: function (component, event, helper) {
      var selectedBoat = event.getParams("boatSelected");
        component.set("v.Id",selectedBoat.boatSelected.Id);
        component.set("v.boat",selectedBoat.boatSelected);

        var recordDataSvc = component.find("service");
        recordDataSvc.set("v.recordId", selectedBoat.boatSelected.Id);
        recordDataSvc.reloadRecord();
    },
    onRecordUpdated: function(component,event,helper){

    },
    onBoatReviewAdded: function(component,event,helper){
        component.find("alltabs").set("v.selectedTabId", "boatreviewtab");
        component.find("boatReview").refresh();
    }
})