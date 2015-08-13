class PopupAlertView {
    class func confirm(viewController: UIViewController, message: String, yes: () -> ()) {
        let ac = UIAlertController(title: I18n.confirmation, message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: I18n.no, style: .Cancel, handler: nil))
        ac.addAction(UIAlertAction(title: I18n.yes, style: .Default, handler: { _ in yes() }))
        viewController.presentViewController(ac, animated: true, completion: nil)
    }
}