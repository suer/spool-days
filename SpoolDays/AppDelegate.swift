import BackgroundTasks
import UIKit
import UserNotifications

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
        window!.addSubview(navigationController.view)
        window!.rootViewController = navigationController
        registerNotification(application)
        setupStyle()

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "org.codefirst.SpoolDays.app-refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }

        return true
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()

        let operation = BlockOperation {
            self.updateBadge { result in
                task.setTaskCompleted(success: result == .newData)
            }
        }

        task.expirationHandler = {
            operation.cancel()
        }

        operation.start()
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "org.codefirst.SpoolDays.app-refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    fileprivate func registerNotification(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
                return
            }
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }

    fileprivate func setupStyle() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = ThemeColor.baseColor()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ThemeColor.baseTextColor()
        ]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

        UITableViewCell.appearance().separatorInset = UIEdgeInsets.zero
    }

    fileprivate func updateBadge(_ completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let baseDate = BaseDate.first() {
            let badgeNumber = abs(baseDate.dateInterval())
            UNUserNotificationCenter.current().setBadgeCount(badgeNumber) { error in
                if error == nil {
                    completionHandler(.newData)
                } else {
                    completionHandler(.failed)
                }
            }
        } else {
            UNUserNotificationCenter.current().setBadgeCount(0) { _ in
                completionHandler(.failed)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        updateBadge({ _ in return })
        scheduleAppRefresh()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        updateBadge({ _ in return })
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.save()
    }

    func applicationSignificantTimeChange(_ application: UIApplication) {
        onSignificantTimeChange?()
    }
}

extension Notification.Name {
    static let didSaveOrDeleteDate = Notification.Name("didSaveOrDeleteDate")
}
