import UIKit
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var onSignificantTimeChange: (() -> ())?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        MagicalRecord.setupCoreDataStack(withStoreNamed: "spooldays.sqlite3")
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        window!.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: MainViewController())
        window!.addSubview(navigationController.view)
        window!.rootViewController = navigationController
        registerNotification(application)
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        setupStyle()
        return true
    }

    fileprivate func registerNotification(_ application: UIApplication) {
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: ([UIUserNotificationType.sound, UIUserNotificationType.alert, UIUserNotificationType.badge]), categories: nil))
            application.registerForRemoteNotifications()
        }
    }

    fileprivate func setupStyle() {
        UINavigationBar.appearance().barTintColor = ThemeColor.baseColor()
        UINavigationBar.appearance().tintColor = ThemeColor.baseTextColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: ThemeColor.baseTextColor()
        ]
        UITabBar.appearance().barTintColor = ThemeColor.baseColor()
        UITabBar.appearance().tintColor = ThemeColor.baseTextColor()
        UITabBarItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: ThemeColor.baseTextColor()
            ], for: UIControlState.selected)

        UITableViewCell.appearance().separatorInset = UIEdgeInsets.zero

        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        updateBadge(completionHandler)
    }

    fileprivate func updateBadge(_ completionHandler: (UIBackgroundFetchResult) -> Void) {
        if let baseDate = BaseDate.first() {
            UIApplication.shared.applicationIconBadgeNumber = abs(baseDate.dateInterval())
            completionHandler(UIBackgroundFetchResult.newData)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
            completionHandler(UIBackgroundFetchResult.failed)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        updateBadge({_ in return})
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        updateBadge({_ in return})
    }

    func applicationWillTerminate(_ application: UIApplication) {
        MagicalRecord.cleanUp()
    }

    func applicationSignificantTimeChange(_ application: UIApplication) {
        onSignificantTimeChange?()
    }
}

