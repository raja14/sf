/**
 * Created by rvivek on 3/3/2018.
 */
({
    onFormSubmit : function (component,event,helper) {
        var formData = event.getParam("formData");
        console.log(formData);
        component.find("boatSearchResults").search(formData.boatTypeId);
    },
    search : function (component,event,helper) {
        var formData = event.getParam("formData");
        var actionSearch = component.find("search");
        actionSearch.search(formData);
    }
})