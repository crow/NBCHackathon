import UIKit
import AVFoundation
import AirshipKit

class  NBCHackathonPushHandler: NSObject, UAPushNotificationDelegate {

    let lastPushPayloadKey = "com.urbanairship.last_push"
    static let shared =  NBCHackathonPushHandler()

    override init() {
        super.init()
    }

    func receivedBackgroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        saveLastPayload(lastPayload: notificationContent)

        // Application received a background notification
        print("The application received a background notification");

        // Call the completion handler
        completionHandler(.noData)
    }

    func receivedForegroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping () -> Swift.Void) {
        // Application received a foreground notification
        print("The application received a foreground notification");

        // iOS 10 - let foreground presentations options handle it
        if (ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0))) {
            completionHandler()
            return
        }

        // iOS 8 & 9 - show an alert dialog
        let alertController: UIAlertController = UIAlertController()
        alertController.title = notificationContent.alertTitle ?? NSLocalizedString("UA_Notification_Title", tableName: "UAPushUI", comment: "System Push Settings Label")
        alertController.message = notificationContent.alertBody

        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (UIAlertAction) -> Void in

            // If we have a message ID run the display inbox action to fetch and display the message.
            let messageID = UAInboxUtils.inboxMessageID(fromNotification: notificationContent.notificationInfo)
            if (messageID != nil) {
                UAActionRunner.runAction(withName: kUADisplayInboxActionDefaultRegistryName, value: messageID, situation: UASituation.manualInvocation)
            }
        }

        alertController.addAction(okAction)


        let topController = UIApplication.shared.keyWindow!.rootViewController! as UIViewController
        alertController.popoverPresentationController?.sourceView = topController.view
        topController.present(alertController, animated:true, completion:nil)

        completionHandler()
    }

    func receivedNotificationResponse(_ notificationResponse: UANotificationResponse, completionHandler: @escaping () -> Swift.Void) {
        saveLastPayload(lastPayload: notificationResponse.notificationContent)

        print("The user selected the following action identifier:%@", notificationResponse.actionIdentifier);
        
        // Call the completion handler
        completionHandler()
    }

    @available(iOS 10.0, *)
    func presentationOptions(for notification: UNNotification) -> UNNotificationPresentationOptions {
        return [.alert, .sound]
    }

    func saveLastPayload(lastPayload: UANotificationContent) {
        UserDefaults.standard.setValue(lastPayload.notificationInfo, forKey: lastPushPayloadKey)
    }
    

}
