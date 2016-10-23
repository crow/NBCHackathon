 

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


class AddNamedUserTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var addNamedUserTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addNamedUserTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        UAirship.shared().analytics.trackScreen("AddNamedUserTableViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"AddNamedUserTableViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    override func viewWillAppear(_ animated: Bool) {
        if ((UAirship.namedUser().identifier) != nil) {
            addNamedUserTextField.text = UAirship.namedUser().identifier
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        if (textField.text?.characters.count > 0){
            UAirship.namedUser().identifier = textField.text
        } else {
            UAirship.namedUser().identifier = nil
        }

        UAirship.push().updateRegistration()

        return navigationController?.popViewController(animated: true) != nil
    }
}
