import AirshipKit

class GimbalAdapter: NSObject, GMBLPlaceManagerDelegate {

    // Set up the Gimbal Adapter singleton
    static let shared = GimbalAdapter()
    
    var started: Bool
    let placeManager: GMBLPlaceManager
    
    let source: String = "Gimbal"
    
    override init() {
        started = false
        placeManager = GMBLPlaceManager()
        
        // Hide the BLE power status alert to prevent duplicate alerts
        if (UserDefaults.standard.value(forKey: "gmbl_hide_bt_power_alert_view") == nil) {
                UserDefaults.standard.set(true, forKey: "gmbl_hide_bt_power_alert_view")
        }
    }
    
    func startAdapter () {
    
        guard (!started) else {
            return
        }
        
        //Set place manager delegate to self
        placeManager.delegate = self
        
        GMBLPlaceManager.startMonitoring()

        print("Started Gimbal Adapter");
        
    }
    
    func stopAdapter () {
        
        guard (started) else {
            return
        }
        
        GMBLPlaceManager.stopMonitoring()
        started = false
            
        print("Stopped Gimbal Adapter");
    }
    
    func bluetoothPoweredOffAlertEnabled (_ bluetoothPoweredOffAlertEnabled: Bool) {
        UserDefaults.standard.set(!bluetoothPoweredOffAlertEnabled, forKey: "gmbl_hide_bt_power_alert_view")
    }
    
    func reportPlaceToAnalytics (_ place: GMBLPlace, boundaryEvent: UABoundaryEvent) {
        let regionEvent: UARegionEvent = UARegionEvent(regionID: place.identifier, source: source, boundaryEvent: boundaryEvent)!
        
        UAirship.shared().analytics.add(regionEvent)
    }
    
    func placeManager(_ manager: GMBLPlaceManager, didBegin visit: GMBLVisit) {
        reportPlaceToAnalytics(visit.place, boundaryEvent: UABoundaryEvent.enter)
    }
    
    func placeManager(_ manager: GMBLPlaceManager, didEnd visit: GMBLVisit) {
        reportPlaceToAnalytics(visit.place, boundaryEvent: UABoundaryEvent.exit)
    }
    
}
