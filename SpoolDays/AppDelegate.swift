import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        MagicalRecord.setupCoreDataStackWithStoreNamed("spooldays.sqlite3")
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: MainViewController())
        window!.addSubview(navigationController.view)
        window!.rootViewController = navigationController
        registerNotification(application)
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        setupStyle()
        return true
    }

    private func registerNotification(application: UIApplication) {
        if application.respondsToSelector(Selector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: (UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge), categories: nil))
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound | UIRemoteNotificationType.Alert)
        }
    }

    private func setupStyle() {
        UINavigationBar.appearance().barTintColor = ThemeColor.baseColor()
        UINavigationBar.appearance().tintColor = ThemeColor.baseTextColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: ThemeColor.baseTextColor()
        ]
        UITabBar.appearance().barTintColor = ThemeColor.baseColor()
        UITabBar.appearance().tintColor = ThemeColor.baseTextColor()
        UITabBarItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: ThemeColor.baseTextColor()
            ], forState: UIControlState.Selected)

        UITableViewCell.appearance().separatorInset = UIEdgeInsetsZero

        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    }

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        updateBadge(completionHandler)
    }

    private func updateBadge(completionHandler: (UIBackgroundFetchResult) -> Void) {
        let baseDate = BaseDateWrapper.first()
        if baseDate == nil {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            completionHandler(UIBackgroundFetchResult.Failed)
            return
        }

        UIApplication.sharedApplication().applicationIconBadgeNumber = abs(BaseDateWrapper(baseDate: baseDate!).dateInterval())
        completionHandler(UIBackgroundFetchResult.NewData)
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        updateBadge({result in return})
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        updateBadge({result in return})
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }
}

