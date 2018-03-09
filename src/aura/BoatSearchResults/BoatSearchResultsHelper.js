/**
 * Created by rvivek on 3/3/2018.
 */
({
    onSearch : function (component,event) {
        var action = component.get("c.getBoats");
        var boatTypeId = component.get("v.boatTypeId");
        action.setParams({
            boatTypeId  : boatTypeId
        });
        action.setCallback(this,function (response) {
            var state=response.getState();
            if(state==="SUCCESS"){
                component.set("v.boats",response.getReturnValue());
            }else{
                console.log(response.getError()[0]);
            }

        });
        $A.enqueueAction(action);
    }
})