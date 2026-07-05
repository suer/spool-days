import UIKit

class PopupAlertView {
    @MainActor class func confirm(_ viewController: UIViewController, message: String, yes: @escaping () -> Void) {
        let ac = UIAlertController(title: String(localized: .confirmation), message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: String(localized: .no), style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: String(localized: .yes), style: .default, handler: { _ in yes() }))
        viewController.present(ac, animated: true, completion: nil)
    }
}
