import UIKit

class DateTableViewCell: UITableViewCell {
    var dateViewModel: DateViewModel

    init(reuseIdentifier: String?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)
        loadButtons()
        updateLabels()
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

    fileprivate func updateLabels() {
        if let baseDate = dateViewModel.baseDate {
            textLabel?.text = baseDate.title
            detailTextLabel?.text = "\(baseDate.dateInterval()) " + I18n.translate("Days")
        }
    }

    fileprivate func loadButtons() {
        let resetButton = UIButton(type: .custom)
        resetButton.backgroundColor = ThemeColor.resetColor()
        resetButton.setTitle(I18n.reset, for: UIControl.State())
        resetButton.setTitleColor(UIColor.white, for: UIControl.State())
        resetButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}
