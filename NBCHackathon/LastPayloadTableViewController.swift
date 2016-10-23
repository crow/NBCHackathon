 

import UIKit
import AirshipKit

class LastPayloadTableViewController: UITableViewController {

    @IBOutlet var lastPushPayloadTextView: UITextView!
    
    let lastPushPayloadKey = "com.urbanairship.last_push"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Add refresh button
        let refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(LastPayloadTableViewController.refreshView));
        
        navigationItem.rightBarButtonItem = refreshButton
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        UAirship.shared().analytics.trackScreen("LastPayloadTableViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"LastPayloadTableViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshView() {
        
        guard UserDefaults.standard.value(forKey: lastPushPayloadKey) != nil else {
            self.lastPushPayloadTextView.text = "Payload is empty. Send a push notification!"
            return
        }
        
        self.lastPushPayloadTextView.text = (UserDefaults.standard.value(forKey: lastPushPayloadKey)! as AnyObject).description
    }
}
