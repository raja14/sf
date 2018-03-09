/**
 * Created by rvivek on 3/3/2018.
 */
({
    lazyLoadTabs: function (cmp, event) {
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case 'details' :
                this.injectComponent('c:BoatDetail', tab);
                break;
            case 'reviews' :
                this.injectComponent('c:BoatDetail', tab);
                break;
            case 'addReview' :
                this.injectComponent('c:BoatDetail', tab);
                break;
        }
    },
    injectComponent: function (name, target) {
        $A.createComponent(name, {
        }, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                target.set('v.body', contentComponent);
            } else {
                throw new Error(error);
            }
        });
    }
})