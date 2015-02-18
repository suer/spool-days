class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    var textField: UITextField?
    var valueChanged: (String -> ())?
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(value: String, placeHolder: String, reuserIdentifier: String) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuserIdentifier)
        textField = UITextField()
        textField!.placeholder = placeHolder
        textField!.text = value
        textField!.delegate = self
        textField!.autocapitalizationType = .None
        contentView.addSubview(textField!)

        textField!.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        let topConstraint = NSLayoutConstraint(item: textField!, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: textField!, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let leftConstraint = NSLayoutConstraint(item: textField!, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 15.0)
        let rightConstraint = NSLayoutConstraint(item: textField!, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: -20.0)
        contentView.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])

        textField!.addTarget(self, action: Selector("textChanged"), forControlEvents: .EditingChanged)
    }

    func textChanged() {
        if let delegate = valueChanged {
            delegate(getValue())
        }
    }

    func focusOnTextField() {
        textField!.becomeFirstResponder()
    }

    func blurOnTextField() {
        textField!.resignFirstResponder()
    }

    func getValue() -> String {
        return textField!.text
    }
}