 

import UIKit
import AirshipKit

class CustomEventTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var eventNameTextField: UITextField!
    @IBOutlet var eventValueTextField: UITextField!
    @IBOutlet var interactionIDTextField: UITextField!
    @IBOutlet var interactionTypeTextField: UITextField!
    @IBOutlet var transactionIDTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventNameTextField.delegate = self
        eventValueTextField.delegate = self
        interactionIDTextField.delegate = self
        interactionTypeTextField.delegate = self
        transactionIDTextField.delegate = self
        
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(CustomEventTableViewController.addEvent))
        navigationItem.rightBarButtonItem = addButton

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomEventTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        UAirship.shared().analytics.trackScreen("CustomEventTableViewController")

//        // Initialize an Urban Airship tracker
//        let tracker:UATracker = UATracker(gaTracker: GAI.sharedInstance().defaultTracker);
//
//        // Enable GA tracker (enabled by default)
//        tracker.googleAnalyticsEnabled = true;
//
//        // Enable UA tracker (enabled by default)
//        tracker.urbanAirshipEnabled = true;
//
//        tracker.set(kGAIScreenName, value:"CustomEventTableViewController")
//
//        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    func addEvent () {
        
        guard validateCustomEvent() else {
         return
        }
        
        let customEvent: UACustomEvent = UACustomEvent(name: eventNameTextField.text!, value: NSDecimalNumber(string: eventValueTextField.text!))
        
        customEvent.interactionID = interactionIDTextField.text
        customEvent.interactionType = interactionTypeTextField.text
        customEvent.transactionID = transactionIDTextField.text
        
        UAirship.shared().analytics.add(customEvent)
        displayMessage("Custom Event added!")

        clearTextFields()
    }
    
    
    
    func validateCustomEvent () -> Bool {
    
        guard eventNameTextField.text != "" && eventValueTextField.text != "" else {
            
            displayMessage("Custom event must have a name and a value")
            
            return false
        }

        guard isNumeric(eventValueTextField.text) else {

            displayMessage("Custom event value must be numeric")

            return false
        }

        return true
    }

    func isNumeric(_ numericString: String?) -> Bool
    {
        guard (numericString != nil) else {
            return false
        }

        let scanner = Scanner(string: numericString!)

        scanner.locale = NSLocale.current

        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }

    func displayMessage (_ messageString: String) {
        
        let alertController = UIAlertController(title: "Notice", message: messageString, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    func clearTextFields () {
        eventNameTextField.text = nil
        eventValueTextField.text = nil
        interactionIDTextField.text = nil
        interactionTypeTextField.text = nil
        transactionIDTextField.text = nil
    }
}
