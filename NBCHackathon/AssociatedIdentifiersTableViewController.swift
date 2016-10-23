import UIKit
import AdSupport.ASIdentifierManager
import AirshipKit

let customIdentifiersKey = "ua_custom_identifiers"

class AssociatedIdentifiersTableViewController: UITableViewController, AssociateIdentifierDelegate {

    let addIdentifiersSegue:String = "addIdentifiersSegue"
    var customIdentifiers = Dictionary<String, String>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(AssociatedIdentifiersTableViewController.addIdentifier))
        navigationItem.rightBarButtonItem = addButton

        if ((UserDefaults.standard.object(forKey: customIdentifiersKey)) != nil) {
            self.customIdentifiers = (UserDefaults.standard.object(forKey: customIdentifiersKey)) as! Dictionary
        } else {
            self.customIdentifiers = Dictionary<String, String>()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        tableView.reloadData()

        UAirship.shared().analytics.trackScreen("AssociatedIdentifiersTableViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"AssociatedIdentifiersTableViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AddAssociatedIdentifiersTableViewController {
            viewController.identifierDelegate = self
        }
    }

    func addIdentifier() {
        performSegue(withIdentifier: addIdentifiersSegue, sender: self)
    }

    func associateIdentifiers(_ identifiers: Dictionary<String, String>) {
        // Set the advertising and vendor ID
        let associateIdentifiers = UAAssociatedIdentifiers.init(dictionary: identifiers)
        associateIdentifiers.advertisingID = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        associateIdentifiers.advertisingTrackingEnabled = !ASIdentifierManager.shared().isAdvertisingTrackingEnabled
        associateIdentifiers.vendorID = UIDevice.current.identifierForVendor?.uuidString

        // Associate the identifiers
        UAirship.shared().analytics.associateDeviceIdentifiers(associateIdentifiers)

        // Update the tableview with current associated identifiers
        self.customIdentifiers = identifiers
        var identifierArray:[String] = []
        if (customIdentifiers.count > 0) {
            for (customKey, customValue) in customIdentifiers {
                let keyValueIdentifier:String = customKey + ":" + customValue
                identifierArray.append(keyValueIdentifier)
            }
        }
        let index:Int = identifierArray.count - 1
        let indexArray:NSArray = NSArray.init(object: IndexPath.init(row:index, section:0))
        self.tableView.insertRows(at: indexArray as! [IndexPath], with: UITableViewRowAnimation.top)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (customIdentifiers.count > 0) {
            var identifierArray:[String] = []
            for (customKey, customValue) in customIdentifiers {
                let keyValueIdentifier:String = customKey + ":" + customValue
                identifierArray.append(keyValueIdentifier)
            }
            return identifierArray.count;
        } else {
            return 0;
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "associatedIdentifierCell", for: indexPath)

        if (cell.isEqual(nil)) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier:"associatedIdentifierCell")
        }

        var identifierArray:[String] = []
        if (customIdentifiers.count > 0) {
            for (customKey, customValue) in customIdentifiers {
                let keyValueIdentifier:String = customKey + ":" + customValue
                identifierArray.append(keyValueIdentifier)
            }
        }
        cell.textLabel!.text = identifierArray[(indexPath as NSIndexPath).row];

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete &&
            tableView.cellForRow(at: indexPath)?.textLabel?.text?.isEmpty == false) {

                var identifierArray:[String] = []
                if (customIdentifiers.count > 0) {
                    for (customKey, customValue) in customIdentifiers {
                        let keyValueIdentifier:String = customKey + ":" + customValue
                        identifierArray.append(keyValueIdentifier)
                    }
                }
                let identifierToDelete:String = identifierArray[(indexPath as NSIndexPath).row]
                var deleteIdentifierArray:[String] = identifierToDelete.components(separatedBy: ":")
                let deleteKey:String = deleteIdentifierArray[0]

                customIdentifiers.removeValue(forKey: deleteKey)
                UserDefaults.standard.set(customIdentifiers, forKey: customIdentifiersKey)
                tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
