/**
 * Created by rvivek on 3/3/2018.
 */
({
    doInit : function(component,event,helper){
       helper.onInit(component,event);
    },
    onSave : function (component,event,helper){
        // component.set("v.boatReview.Boat__c",component.get("v.boat.Id"));
        component.find("service").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // record is saved successfully
                var resultsToast = $A.get("e.force:showToast");
                if (resultsToast) {
                    resultsToast.setParams({
                        "title": "Submitted",
                        "message": "The review was saved.",
                        "type" : "success"
                    });
                    resultsToast.fire();
                } else {
                    alert('The review was saved.');
                }
                helper.onInit(component, event);

                var boatReviewAddedEvent = component.getEvent("boatReviewAdded");
                boatReviewAddedEvent.fire();
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log('Problem saving contact, error: ' +
                    JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state +
                    ', error: ' + JSON.stringify(saveResult.error));
            }
        });
    },
    onRecordUpdated: function (component, event, helper) {
     console.log('record updated');
    }
})