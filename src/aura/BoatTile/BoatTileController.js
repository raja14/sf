/**
 * Created by rvivek on 3/3/2018.
 */
({
    onBoatClick : function(component,event,helper){
      // component.set("v.selected",true);
    var boatSelectEvent = component.getEvent("boatSelect");
    var boatId = component.get("v.boat");
        boatSelectEvent.setParams({
        "boatId" : boatId
    });
        boatSelectEvent.fire();

        var boatSelectedAppEvent = $A.get("e.c:BoatSelected");
        boatSelectedAppEvent.setParams({
            "boatSelected" : boatId
        });
        boatSelectedAppEvent.fire();

        var plotMapMarker  = $A.get("e.c:PlotMapMarker");
        plotMapMarker.setParams({
            "lat" : boatId.Geolocation__Latitude__s,
            "long" : boatId.Geolocation__Longitude__s
        }); 
        plotMapMarker.fire();
    }
})