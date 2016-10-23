
import UIKit
import AirshipKit

class HomeViewController: UIViewController {
    
    @IBOutlet var enablePushButton: UIButton!
    @IBOutlet var channelIDButton: UIButton!
    @IBOutlet var bleatButton: UIButton!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var airshipVersionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(HomeViewController.refreshView),
            name: NSNotification.Name(rawValue: "channelIDUpdated"),
            object: nil);

        versionLabel.text = "App Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)"
        airshipVersionLabel.text = "Airship Version: \(UAirshipVersion.get())"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        UAirship.shared().analytics.trackScreen("HomeViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"HomeViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshView()
        bleatButton.setTitle("Push", for: UIControlState())

    }

    func refreshView () {
        if (UAirship.push() != nil && UAirship.push().userPushNotificationsEnabled) {
            // Push is enabled
            channelIDButton.setTitle(UAirship.push().channelID, for: UIControlState())
            channelIDButton.isHidden = false
            enablePushButton.isHidden = true
            bleatButton.isHidden = false
            return
        }
        // Push is not yet enabled
        channelIDButton.isHidden = true
        enablePushButton.isHidden = false
        bleatButton.isHidden = true
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {

        if (sender == enablePushButton) {
            UAirship.push().userPushNotificationsEnabled = true
        }

        if (sender == bleatButton) {

            guard (UAirship.push().channelID != nil) else {
                return
            }

            BleatClient().bleatAlert("Hello!", soundFile: nil);
        }

        //The channel ID will need to wait for push registration to return the channel ID
        if (sender == channelIDButton) {
            if ((UAirship.push().channelID) != nil) {
                UIPasteboard.general.string = UAirship.push().channelID
                let message = UAInAppMessage()
                message.alert = NSLocalizedString("UA_Copied_To_Clipboard", tableName: "UAPushUI", comment: "Copied to clipboard string")
                message.position = UAInAppMessagePosition.top
                message.duration = 0.5
                message.primaryColor = UIColor(red: 0/255, green: 105/255, blue: 143/255, alpha: 1)
                message.secondaryColor = UIColor(red: 255/255, green: 200/255, blue: 40/255, alpha: 1)
                UAirship.inAppMessaging().display(message)
            }
        }
    }
}

