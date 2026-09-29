import UIKit

extension UIViewController {
    func presentConfirmation(message: String, style: UIAlertAction.Style = .default, yes: @escaping () -> Void) {
        let ac = UIAlertController(title: String(localized: .confirmation), message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: String(localized: .no), style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: String(localized: .yes), style: style, handler: { _ in yes() }))
        present(ac, animated: true, completion: nil)
    }
}
