import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var onSignificantTimeChange: (() -> Void)?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = CoreDataManager.shared
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = .systemBackground
        window!.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: MainViewController())
        navigationController.setupStyle()
        window!.addSubview(navigationController.view)
        window!.rootViewController = navigationController
        registerNotification(application)
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        setupStyle()
        return true
    }

    fileprivate func registerNotification(_ application: UIApplication) {
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(
                types: ([UIUserNotificationType.sound, UIUserNotificationType.alert, UIUserNotificationType.badge]),
                categories: nil)
            )
            application.registerForRemoteNotifications()
        }
    }

    fileprivate func setupStyle() {
        UINavigationBar.appearance().barTintColor = ThemeColor.baseColor()
        UINavigationBar.appearance().tintColor = ThemeColor.baseTextColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ThemeColor.baseTextColor()
        ]
        UITabBar.appearance().barTintColor = ThemeColor.baseColor()
        UITabBar.appearance().tintColor = ThemeColor.baseTextColor()
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: ThemeColor.baseTextColor()
            ], for: UIControl.State.selected)

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
        CoreDataManager.shared.save()
    }

    func applicationSignificantTimeChange(_ application: UIApplication) {
        onSignificantTimeChange?()
    }
}
