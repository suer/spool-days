import UIKit

class TextFieldTableViewCell: UITableViewCell {

    private let textField = UITextField()
    var valueChanged: ((String) -> Void)?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(value: String, placeHolder: String, reuserIdentifier: String) {
        super.init(style: .default, reuseIdentifier: reuserIdentifier)
        textField.placeholder = placeHolder
        textField.text = value
        textField.autocapitalizationType = .none
        textField.font = .preferredFont(forTextStyle: .body)
        contentView.addSubview(textField)

        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11),
            textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])

        textField.addTarget(self, action: #selector(TextFieldTableViewCell.textChanged), for: .editingChanged)
    }

    @objc func textChanged() {
        valueChanged?(getValue())
    }

    func focusOnTextField() {
        textField.becomeFirstResponder()
    }

    func blurOnTextField() {
        textField.resignFirstResponder()
    }

    func getValue() -> String {
        return textField.text ?? ""
    }
}
