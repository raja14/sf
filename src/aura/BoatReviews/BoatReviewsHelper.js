/**
 * Created by rvivek on 3/4/2018.
 */
({
    onInit : function (component, event) {
        var action = component.get("c.getAll");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                component.set("v.boatReviews",response.getReturnValue());
            }else{
                console.log("Error while retrieving the boat result");
            }
        });
        $A.enqueueAction(action); 
    }
})