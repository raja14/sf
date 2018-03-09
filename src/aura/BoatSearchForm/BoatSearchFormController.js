/**
 * Created by rvivek on 2/28/2018.
 */
({
    doInit : function (component, event, helper) {
        var action = component.get("c.getBoatTypes");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state==="SUCCESS"){
                component.set("v.boatTypes",response.getReturnValue());
                // component.find("boatTypeDD").set("v.options",response.getReturnValue());
            }
        })
        $A.enqueueAction(action);
        var isRecordCreateEnabled = $A.get("e.force:createRecord");
        component.set('v.isRecordCreateEnabled',true);
    },
    handleChange : function (component, event, helper) {
      component.set("v.selectedBoatType",component.find("boatTypeDD").get("v.value"));
    },
    createNewBoat : function (component,event,helper){
        var boatTypeId = component.get("v.selectedBoatType");
        var createBoat = $A.get("e.force:createRecord");
        createBoat.setParams({
        "entityApiName": "Boat__c",
    })
        if(!boatTypeId==""){
            createBoat.setParams({
                    "defaultFieldValues": {'BoatType__c': boatTypeId}
        })
        }
        createBoat.fire();
    },
    onFormSubmit : function(component,event,helper){
        var formsubmitEvent = component.getEvent("formsubmit");
        
        formsubmitEvent.setParams({"formData":
        {"boatTypeId" : component.get("v.selectedBoatType")}
        });
        formsubmitEvent.fire();
    }
})