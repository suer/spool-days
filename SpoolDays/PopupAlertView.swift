class PopupAlertView {
    class func confirm(_ viewController: UIViewController, message: String, yes: @escaping () -> ()) {
        let ac = UIAlertController(title: I18n.confirmation, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: I18n.no, style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: I18n.yes, style: .default, handler: { _ in yes() }))
        viewController.present(ac, animated: true, completion: nil)
    }
}
