import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var onSignificantTimeChange: (() -> ())?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        MagicalRecord.setupCoreDataStackWithStoreNamed("spooldays.sqlite3")
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: MainViewController())
        window!.addSubview(navigationController.view)
        window!.rootViewController = navigationController
        registerNotification(application)
        startMintSession()
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        setupStyle()
        return true
    }

    private func registerNotification(application: UIApplication) {
        if application.respondsToSelector(Selector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: ([UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge]), categories: nil))
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotificationTypes([UIRemoteNotificationType.Badge, UIRemoteNotificationType.Sound, UIRemoteNotificationType.Alert])
        }
    }

    private func startMintSession() {
        let apiKey = Preference().mintAPIKey
        if !apiKey.isEmpty {
            Mint.sharedInstance().initAndStartSession(apiKey)
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
        if let baseDate = BaseDate.first() {
            UIApplication.sharedApplication().applicationIconBadgeNumber = abs(baseDate.dateInterval())
            completionHandler(UIBackgroundFetchResult.NewData)
        } else {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            completionHandler(UIBackgroundFetchResult.Failed)
        }
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        updateBadge({_ in return})
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        updateBadge({_ in return})
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }

    func applicationSignificantTimeChange(application: UIApplication) {
        onSignificantTimeChange?()
    }
}

