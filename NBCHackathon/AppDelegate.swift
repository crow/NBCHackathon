import UIKit
import AVKit
import AdSupport.ASIdentifierManager
import AirshipKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UARegistrationDelegate {

    let simulatorWarningDisabledKey = "ua-simulator-warning-disabled"
    var inboxDelegate: InboxDelegate?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        self.failIfSimulator()
        
        // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
        // or set runtime properties here.
        let config = UAConfig.default()


        // Call takeOff (which creates the UAirship singleton)
        UAirship.takeOff(config)

        // Print out the application configuration for debugging (optional)
        print("Config:\n \(config)")

        // Set log level for debugging config loading (optional)
        // It will be set to the value in the loaded config upon takeOff
        UAirship.setLogLevel(UALogLevel.trace)

        // Set the icon badge to zero on startup (optional)
        UAirship.push()?.resetBadge()
        
        let customConfig: Dictionary = config.customConfig as Dictionary

        if let gimbalAPIkey = customConfig["gimbalApiKey"] {
            Gimbal.setAPIKey(gimbalAPIkey as! String, options: nil)
            
            // Start adapter if it's been previously started
            if UserDefaults.standard.bool(forKey: "ua-gimbal-adapter-enabled") {
                GimbalAdapter.shared.startAdapter()
            }
            
        } else {
            print("No gimbal API key found in custom config, skipping gimbal setup")
        }

        UAirship.location().isBackgroundLocationUpdatesAllowed = true

        UAirship.push().pushNotificationDelegate =  NBCHackathonPushHandler.shared
        UAirship.push().registrationDelegate = self

        // Define an action for the category
        let categoryAction = UANotificationAction(identifier: "category_action",
                                                  title: "Custom Action!",
                                                  options: [.authenticationRequired, .foreground, .destructive])

        // Define the category
        let category = UANotificationCategory(identifier: "custom_category",
                                              actions: [categoryAction],
                                              intentIdentifiers: [],
                                              options: [])

        // Set the custom categories
        UAirship.push().customCategories = [category]
        
        // Update registration
        UAirship.push().updateRegistration()

        // If failing here check config
        assert(UAirship.shared() != nil)

        inboxDelegate = InboxDelegate(rootViewController: (window?.rootViewController)!)
        UAirship.inbox().delegate = inboxDelegate

        NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.refreshMessageCenterBadge), name: NSNotification.Name.UAInboxMessageListUpdated, object: nil)

        var customIdentifiers = Dictionary<String, String>()
        if ((UserDefaults.standard.object(forKey: customIdentifiersKey)) != nil) {
            customIdentifiers = (UserDefaults.standard.object(forKey: customIdentifiersKey)) as! Dictionary
        } else {
            customIdentifiers = Dictionary<String, String>()
        }

        // Set the advertising and vendor ID
        let associateIdentifiers = UAAssociatedIdentifiers.init(dictionary: customIdentifiers)
        associateIdentifiers.advertisingID = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        associateIdentifiers.advertisingTrackingEnabled = !ASIdentifierManager.shared().isAdvertisingTrackingEnabled
        associateIdentifiers.vendorID = UIDevice.current.identifierForVendor?.uuidString

        UAirship.shared().analytics.associateDeviceIdentifiers(associateIdentifiers);

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        refreshMessageCenterBadge()
    }

    func refreshMessageCenterBadge() {

        if self.window?.rootViewController is UITabBarController {
            let messageCenterTab: UITabBarItem = (self.window!.rootViewController! as! UITabBarController).tabBar.items![2]

            if (UAirship.inbox().messageList.unreadCount > 0) {
                messageCenterTab.badgeValue = String(stringInterpolationSegment:UAirship.inbox().messageList.unreadCount)
            } else {
                messageCenterTab.badgeValue = nil
            }
        }
    }

    func failIfSimulator() {
        // If it's not a simulator return early
        if (TARGET_OS_SIMULATOR == 0 && TARGET_IPHONE_SIMULATOR == 0) {
            return
        }
        
        if (UserDefaults.standard.bool(forKey: self.simulatorWarningDisabledKey)) {
            return
        }
        
        let alertController = UIAlertController(title: "Notice", message: "You will not be able to receive push notifications in the simulator.", preferredStyle: .alert)
        let disableAction = UIAlertAction(title: "Disable Warning", style: UIAlertActionStyle.default){ (UIAlertAction) -> Void in
            UserDefaults.standard.set(true, forKey:self.simulatorWarningDisabledKey)
        }
        alertController.addAction(disableAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Let the UI finish launching first so it doesn't complain about the lack of a root view controller
        // Delay execution of the block for 1/2 second.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }

    func registrationSucceeded(forChannelID channelID: String, deviceToken: String) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "channelIDUpdated"),
            object: self,
            userInfo:nil)
    }
    
}

