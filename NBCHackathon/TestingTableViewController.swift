 

import UIKit
import AirshipKit

class TestingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        UAirship.shared().analytics.trackScreen("TestingTableViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"TestingTableViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
