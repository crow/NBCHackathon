 

import UIKit
import CoreBluetooth
import AirshipKit

class PushSettingsViewController: UITableViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet var pushEnabledCell: UITableViewCell!
    @IBOutlet var channelIDCell: UITableViewCell!
    @IBOutlet var namedUserCell: UITableViewCell!
    @IBOutlet var aliasCell: UITableViewCell!
    @IBOutlet var tagsCell: UITableViewCell!
    @IBOutlet var associatedIdentifiersCell:UITableViewCell!
    @IBOutlet var tagGroupsCell:UITableViewCell!
    @IBOutlet var locationEnabledCell: UITableViewCell!
    @IBOutlet var getLocationCell: UITableViewCell!
    @IBOutlet var gimbalEnabledCell: UITableViewCell!
    
    @IBOutlet var pushEnabledSwitch: UISwitch!
    @IBOutlet var locationEnabledSwitch: UISwitch!
    @IBOutlet weak var gimbalEnabled: UISwitch!
    @IBOutlet var analyticsSwitch: UISwitch!
    @IBOutlet var gimbalEnabledSwitch: UISwitch!
    
    @IBOutlet var pushSettingsLabel: UILabel!
    @IBOutlet var pushSettingsSubtitleLabel: UILabel!
    @IBOutlet var locationEnabledLabel: UILabel!
    @IBOutlet var locationEnabledSubtitleLabel: UILabel!
    @IBOutlet var gimbalEnabledLabel: UILabel!
    @IBOutlet var channelIDSubtitleLabel: UILabel!
    @IBOutlet var namedUserSubtitleLabel: UILabel!
    @IBOutlet var aliasSubtitleLabel: UILabel!
    @IBOutlet var tagsSubtitleLabel: UILabel!
    
    var bluetoothPeripheralManager: CBPeripheralManager!
    var bluetoothReady: Bool?
    var alreadyWarnedAboutBluetooth: Bool?
    
    let bluetoothEnabledKey: String = "ua-gimbal-adapter-enabled"
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
        // Only allow disabling user notifications on iOS 10+
        if (ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0))) {
            UAirship.push().userPushNotificationsEnabled = pushEnabledSwitch.isOn
        } else if (pushEnabledSwitch.isOn) {
            UAirship.push().userPushNotificationsEnabled = true
        }
        
        if (gimbalEnabledSwitch.isOn) {
            GimbalAdapter.shared.startAdapter()
        } else {
            GimbalAdapter.shared.stopAdapter()
        }

        UserDefaults.standard.set(gimbalEnabledSwitch.isOn, forKey: bluetoothEnabledKey)

        UAirship.location().isLocationUpdatesEnabled = true
        UAirship.shared().analytics.isEnabled = analyticsSwitch.isOn
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GimbalAdapter.shared.bluetoothPoweredOffAlertEnabled(true)
        
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(PushSettingsViewController.refreshView),
            name: NSNotification.Name(rawValue: "channelIDUpdated"),
            object: nil);
        
        // add observer to didBecomeActive to update upon retrun from system settings screen
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(PushSettingsViewController.didBecomeActive),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        
        locationEnabledLabel.text = NSLocalizedString("UA_Location_Enabled", tableName: "UAPushUI", comment: "Location Enabled label")
        locationEnabledSubtitleLabel.text = NSLocalizedString("UA_Location_Enabled_Detail", tableName: "UAPushUI", comment: "Enable GPS and WIFI Based Location detail label")
        pushEnabledSwitch.isOn = UAirship.push().userPushNotificationsEnabled
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        UAirship.shared().analytics.trackScreen("PushSettingsViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"PushSettingsViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])

        // Initialize switches
        pushEnabledSwitch.isOn = UAirship.push().userPushNotificationsEnabled
        locationEnabledSwitch.isOn = UAirship.location().isLocationUpdatesEnabled
        gimbalEnabledSwitch.isOn = UserDefaults.standard.bool(forKey: bluetoothEnabledKey)
        analyticsSwitch.isOn = UAirship.shared().analytics.isEnabled
        
        peripheralManagerDidUpdateState(bluetoothPeripheralManager)
    }
    
    // this is necessary to update the view when returning from the system settings screen
    func didBecomeActive () {
        refreshView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshView()
    }
    
    func refreshView() {
        channelIDSubtitleLabel?.text = UAirship.push().channelID
        
        aliasSubtitleLabel?.text = UAirship.push().alias == nil ? NSLocalizedString("None", tableName: "UAPushUI", comment: "None") : UAirship.push()?.alias
        
        namedUserSubtitleLabel?.text = UAirship.namedUser().identifier == nil ? NSLocalizedString("None", tableName: "UAPushUI", comment: "None") : UAirship.namedUser().identifier

        if (UAirship.push().tags.count > 0) {
            self.tagsSubtitleLabel?.text = UAirship.push().tags.joined(separator: ", ")
        } else {
            self.tagsSubtitleLabel?.text = NSLocalizedString("None", tableName: "UAPushUI", comment: "None")
        }

        // iOS 8 & 9 - user notifications cannot be disabled, so remove switch and link to system settings
        if (!ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)) && UAirship.push().userPushNotificationsEnabled) {
            pushSettingsLabel.text = NSLocalizedString("UA_Push_Settings_Title", tableName: "UAPushUI", comment: "System Push Settings Label")

            pushSettingsSubtitleLabel.text = pushTypeString()
            pushEnabledSwitch?.isHidden = true
            pushEnabledCell.selectionStyle = .default
        }
    }
    
    func pushTypeString () -> String {
        
        let types = UIApplication.shared.currentUserNotificationSettings?.types
        var typeArray: [String] = []
        
        if (types!.contains(UIUserNotificationType.alert)) {
            typeArray.append(NSLocalizedString("UA_Notification_Type_Alerts", tableName: "UAPushUI", comment: "Alerts"))
        }
        if (types!.contains(UIUserNotificationType.badge)){
            typeArray.append(NSLocalizedString("UA_Notification_Type_Badges", tableName: "UAPushUI", comment: "Badges"))
        }
        if (types!.contains(UIUserNotificationType.sound)) {
            typeArray.append(NSLocalizedString("UA_Notification_Type_Sounds", tableName: "UAPushUI", comment: "Sounds"))
        }
        if (types! == UIUserNotificationType()) {
            return NSLocalizedString("UA_Push_Settings_Link_Disabled_Title", tableName: "UAPushUI", comment: "Pushes Currently Disabled")
        }
        
        return typeArray.joined(separator: ", ")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard (tableView.indexPath(for: pushEnabledCell) != nil && tableView.indexPath(for: channelIDCell) != nil && tableView.indexPath(for: gimbalEnabledCell) != nil) else {
            return
        }

        switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
        case ((tableView.indexPath(for: pushEnabledCell)! as NSIndexPath).section, (tableView.indexPath(for: pushEnabledCell)! as NSIndexPath).row) :
            // iOS 8 & 9 - redirect push enabled cell to system settings
            if (!ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)) && UAirship.push().userPushNotificationsEnabled) {
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }

            break
        case ((tableView.indexPath(for: channelIDCell)! as NSIndexPath).section, (tableView.indexPath(for: channelIDCell)! as NSIndexPath).row) :
            if (UAirship.push().channelID != nil) {
                UIPasteboard.general.string = channelIDSubtitleLabel?.text
                let message = UAInAppMessage()
                message.alert = NSLocalizedString("UA_Copied_To_Clipboard", tableName: "UAPushUI", comment: "Copied to clipboard string")
                message.position = UAInAppMessagePosition.top
                message.duration = 0.5
                message.primaryColor = UIColor(red: 0/255, green: 105/255, blue: 143/255, alpha: 1)
                message.secondaryColor = UIColor(red: 255/255, green: 200/255, blue: 40/255, alpha: 1)
                UAirship.inAppMessaging().display(message)                }
            break
        case ((tableView.indexPath(for: gimbalEnabledCell)! as NSIndexPath).section, (tableView.indexPath(for: gimbalEnabledCell)! as NSIndexPath).row) :
            if (bluetoothReady == false) {
                let alertController = UIAlertController(title: "Bluetooth Error", message: "Bluetooth is currently deactivated. Gimbal places that utilize beacons may not function as expected.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)

            }
     
            break
        default:
            break
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        var stateString: String?
        
        if (bluetoothPeripheralManager.state == .poweredOn) {
            bluetoothReady = true
            gimbalEnabledLabel.text = "Gimbal Enabled"
        } else {
            switch (bluetoothPeripheralManager.state) {
            case .poweredOff:
                gimbalEnabledLabel.text = "Gimbal Enabled ⚠"
                stateString = "Bluetooth is currently powered off. Gimbal places that utilize beacons may not function as expected."
                bluetoothReady = false
            case .unsupported:
                gimbalEnabledLabel.text = "Gimbal Enabled ⚠"
                stateString = "This device does not support Bluetooth Low Energy. Beacon functionality disabled."
                bluetoothReady = false
            case .unauthorized:
                gimbalEnabledLabel.text = "Gimbal Enabled ⚠"
                stateString = "This app is not authorized to use Bluetooth Low Energy. Beacon functionality disabled."
                bluetoothReady = false
            default:
                bluetoothReady = true
                alreadyWarnedAboutBluetooth = false
                break
            }
        }
        
        if (bluetoothReady != true && alreadyWarnedAboutBluetooth != true) {
            let alertController = UIAlertController(title: "Bluetooth Error", message: stateString, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            alreadyWarnedAboutBluetooth = true
        }
        
    }
}
