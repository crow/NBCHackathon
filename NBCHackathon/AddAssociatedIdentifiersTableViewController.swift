 

import UIKit
import AirshipKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol AssociateIdentifierDelegate {
    func associateIdentifiers(_ identifiers: Dictionary<String, String>)
}

class AddAssociatedIdentifiersTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var addCustomKeyTextField: UITextField!
    @IBOutlet var addCustomValueTextField: UITextField!
    var identifierDelegate: AssociateIdentifierDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCustomKeyTextField.delegate = self
        self.addCustomValueTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        UAirship.shared().analytics.trackScreen("AddAssociatedIdentifiersTableViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"AddAssociatedIdentifiersTableViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        if (textField.text?.characters.count > 0){

            var customIdentifiers = Dictionary<String, String>()
            if ((UserDefaults.standard.object(forKey: customIdentifiersKey)) != nil) {
                customIdentifiers = (UserDefaults.standard.object(forKey: customIdentifiersKey)) as! Dictionary
            }
            customIdentifiers[self.addCustomKeyTextField.text!] = self.addCustomValueTextField.text
            UserDefaults.standard.set(customIdentifiers, forKey: customIdentifiersKey)

            self.identifierDelegate!.associateIdentifiers(customIdentifiers)

        } else {
            return false
        }

        return navigationController?.popViewController(animated: true) != nil
    }
}
