import UIKit

class DateTableViewCell: UITableViewCell {
    var dateViewModel: DateViewModel

    init(reuseIdentifier: String?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resetDate() {
        dateViewModel.resetDate()
    }

    func resetDate(_ date: Date) {
        dateViewModel.resetDate(date)
    }

    fileprivate func configure() {
        guard let baseDate = dateViewModel.baseDate else { return }
        setValueContent(text: baseDate.title, secondaryText: "\(baseDate.dateInterval()) " + String(localized: .days))
    }
}

extension UITableViewCell {
    func setValueContent(text: String?, secondaryText: String?) {
        var content = UIListContentConfiguration.valueCell()
        content.text = text
        content.secondaryText = secondaryText
        contentConfiguration = content
    }
}
