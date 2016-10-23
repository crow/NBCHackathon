import Foundation
import AirshipKit

class InboxDelegate : NSObject, UAInboxDelegate {

    var rootViewController : UIViewController

    init(rootViewController:UIViewController) {
        self.rootViewController = rootViewController
    }

    func messageViewController() -> MessageCenterViewController {
        let tabBarController = self.rootViewController as! UITabBarController
        let viewController = tabBarController.viewControllers![2]
        return viewController as! MessageCenterViewController
    }

    func showInbox() {
        let tabBarController = self.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 2
    }

    func show(_ message: UAInboxMessage) {
        self.showInbox()
        self.messageViewController().displayMessage(message)
    }
}


