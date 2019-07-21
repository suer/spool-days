import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    var textField: UITextField?
    var valueChanged: ((String) -> ())?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(value: String, placeHolder: String, reuserIdentifier: String) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuserIdentifier)
        textField = UITextField()
        textField!.placeholder = placeHolder
        textField!.text = value
        textField!.delegate = self
        textField!.autocapitalizationType = .none
        contentView.addSubview(textField!)

        textField!.translatesAutoresizingMaskIntoConstraints = false
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let topConstraint = NSLayoutConstraint(item: textField!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: textField!, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leftConstraint = NSLayoutConstraint(item: textField!, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 15.0)
        let rightConstraint = NSLayoutConstraint(item: textField!, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -20.0)
        contentView.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])

        textField!.addTarget(self, action: #selector(TextFieldTableViewCell.textChanged), for: .editingChanged)
    }

    @objc func textChanged() {
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
        return textField?.text ?? ""
    }
}
