/**
 * Created by rvivek on 2/26/2018.
 */
({
    clickCreateItem : function (component, event, helper) {
        var validItem = component.find('inputform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validItem) {
            helper.createItem(component,event);
        }
    }
})