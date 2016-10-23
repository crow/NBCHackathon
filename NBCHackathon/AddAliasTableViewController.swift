 

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


class AddAliasTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var addAliasTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addAliasTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        UAirship.shared().analytics.trackScreen("AddAliasTableViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"AddAliasTableViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    override func viewWillAppear(_ animated: Bool) {
        if ((UAirship.push().alias) != nil) {
            addAliasTextField.text = UAirship.push().alias
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)


        if (textField.text?.characters.count > 0){
            UAirship.push().alias = textField.text
        } else {
            UAirship.push().alias = nil
        }

        UAirship.push().updateRegistration()



        return navigationController?.popViewController(animated: true) != nil
    }
}
