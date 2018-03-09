/**
 * Created by rvivek on 3/4/2018.
 */
({
    onInit : function(component,event){
        component.find("service").getNewRecord(
            "BoatReview__c",
            null,
            false,
            $A.getCallback(function() {
                var rec = component.get("v.boatReview");
                var error = component.get("v.recordError");
                console.log(JSON.stringify(rec));

                if (error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                } else {
                    rec.Boat__c = component.get("v.boat").Id;
                    component.set("v.boatReview", rec);
                }
            })
        );
    }
})