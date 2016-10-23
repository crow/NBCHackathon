 

import UIKit
import AirshipKit

class TagGroupsTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var addTagGroupIDTextField: UITextField!
    @IBOutlet var addTagTextField: UITextField!
    @IBOutlet var addTagButton: UIButton!
    @IBOutlet var removeTagButton: UIButton!

    @IBOutlet var addTagGroupIDCell: UITableViewCell!
    @IBOutlet var addTagCell: UITableViewCell!
    @IBOutlet var channelTagGroupCell: UITableViewCell!
    @IBOutlet var namedUserTagGroupCell: UITableViewCell!
    @IBOutlet var buttonsCell: UITableViewCell!

    var checkedIndexPath: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTagGroupIDTextField.delegate = self
        self.addTagTextField.delegate = self

        // set default checkmark on Channel Tag Group
        let indexPath: IndexPath = IndexPath(row: 0, section: 1)
        self.checkedIndexPath = indexPath
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        UAirship.shared().analytics.trackScreen("TagGroupsTableViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"TagGroupsTableViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Tag group section
        if ((indexPath as NSIndexPath).section == 0) {
            return (indexPath as NSIndexPath).row == 0 ? self.addTagGroupIDCell : self.addTagCell
        }

        // Named User/Channel Selector
        if ((indexPath as NSIndexPath).section == 1) {
            let typeCell = (indexPath as NSIndexPath).row == 0 ? self.channelTagGroupCell : self.namedUserTagGroupCell

            // Update the checkbox
            if indexPath == self.checkedIndexPath {
                typeCell?.tintColor = UIColor.green
                typeCell?.accessoryType = .checkmark
            } else {
                typeCell?.accessoryType = .none
            }

            return typeCell!
        }

        return self.buttonsCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).section == 1) {
            // uncheck previously selected row
            let uncheckCell: UITableViewCell? = self.tableView.cellForRow(at: self.checkedIndexPath)
            uncheckCell?.accessoryType = .none
            let cell: UITableViewCell? = self.tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            cell?.tintColor = UIColor.green
            self.checkedIndexPath = indexPath
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @IBAction func addRemoveTagButtonPressed(_ sender: UIButton) {

        let newTagGroup: String = self.addTagGroupIDTextField.text!
        let newTag: String = self.addTagTextField.text!

        // Trim leading whitespace
        let trimTagGroup: String = newTagGroup.trimmingCharacters(in: CharacterSet.whitespaces)
        let trimTag: String = newTag.trimmingCharacters(in: CharacterSet.whitespaces)
        let tag: [String] = [trimTag]

        if (sender == addTagButton) {
            if self.checkedIndexPath.row == 0 {
                UAirship.push().addTags(tag, group: trimTagGroup)
            } else {
                UAirship.namedUser().addTags(tag, group: trimTagGroup)
            }
        }

        if (sender == removeTagButton) {
            if self.checkedIndexPath.row == 0 {
                UAirship.push().removeTags(tag, group: trimTagGroup)
            } else {
                UAirship.namedUser().removeTags(tag, group: trimTagGroup)
            }
        }

        if self.checkedIndexPath.row == 0 {
            UAirship.push().updateRegistration()
        } else {
            UAirship.namedUser().updateTags()
        }

        self.addTagGroupIDTextField.text = ""
        self.addTagTextField.text = ""
    }
}
