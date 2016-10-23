import Foundation
import UIKit
import AirshipKit

class MessageCenterViewController : UADefaultMessageCenterSplitViewController {

    override func awakeFromNib() {
        super.awakeFromNib()

        let style = UADefaultMessageCenterStyle()

        let robotoLight = UIFont(name: "Roboto-Light", size: 12.0)
        let robotoBold = UIFont(name: "Roboto-Bold", size: 14.0)
        let robotoRegular = UIFont(name: "Roboto-Regular", size: 17.0)

        style.navigationBarColor = UIColor(red: 0.988, green: 0.694, blue: 0.106, alpha: 1)
        style.titleColor = UIColor(red: 0.039, green: 0.341, blue: 0.490, alpha: 1)
        style.iconsEnabled = true
        style.titleFont = robotoRegular
        style.cellTitleFont = robotoBold
        style.cellDateFont = robotoLight

        self.style = style
    }

    func displayMessage(_ message: UAInboxMessage) {
        self.listViewController.display(message)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        self.title = "My News"

        UAirship.shared().analytics.trackScreen("MessageCenterViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value: "MessageCenterViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }
}
