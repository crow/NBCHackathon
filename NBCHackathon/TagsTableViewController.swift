 

import UIKit
import AirshipKit

class TagsTableViewController: UITableViewController {


    let addTagsSegue:String = "addTagsSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(TagsTableViewController.addTag))
        navigationItem.rightBarButtonItem = addButton
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        tableView.reloadData()
        UAirship.shared().analytics.trackScreen("TagsTableViewController")


//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"TagsTableViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    func addTag () {
        performSegue(withIdentifier: addTagsSegue, sender: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UAirship.push().tags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)

        if cell.isEqual(nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier:"tagCell")
        }
        cell.textLabel!.text = UAirship.push().tags[(indexPath as NSIndexPath).row]

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete &&
            tableView.cellForRow(at: indexPath)?.textLabel?.text?.isEmpty == false) {

            UAirship.push().removeTag((tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
            tableView.deleteRows(at: [indexPath], with: .fade)

            UAirship.push().updateRegistration()
        }
    }
}
