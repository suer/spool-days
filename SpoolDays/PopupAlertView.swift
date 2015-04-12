class PopupAlertView {
    class func confirm(viewController: UIViewController, message: String, yes: () -> ()) {
        RMUniversalAlert.showAlertInViewController(
            viewController,
            withTitle: I18n.confirmation,
            message: message,
            cancelButtonTitle: I18n.no,
            destructiveButtonTitle: nil,
            otherButtonTitles: [I18n.yes]) {
                (alert, index) in
                switch index {
                case alert.firstOtherButtonIndex:
                    yes()
                default:
                    break
                }
        }
    }
}