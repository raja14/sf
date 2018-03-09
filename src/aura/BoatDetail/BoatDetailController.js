/**
 * Created by rvivek on 3/3/2018.
 */
({
    onFullDetails: function (component, event, helper) {
        var navigateToSObjectEvent = $A.get("e.force:navigateToSObject");
        navigateToSObjectEvent.setParams({
            "recordId": component.get("v.boat.Id")
        });
        navigateToSObjectEvent.fire();
    }
})