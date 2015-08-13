import UIKit

class DateTableViewCell: SWTableViewCell {
    var dateViewModel: DateViewModel

    init(reuseIdentifier: String?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        loadButtons()
        updateLabels()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resetDate() {
        dateViewModel.resetDate()
    }

    func resetDate(date: NSDate) {
        dateViewModel.resetDate(date)
    }

    private func updateLabels() {
        if let baseDate = dateViewModel.baseDate {
            textLabel?.text = baseDate.title
            detailTextLabel?.text = "\(baseDate.dateInterval()) " + I18n.translate("Days")
        }
    }

    private func loadButtons() {
        let resetButton = UIButton(type: .Custom)
        resetButton.backgroundColor = ThemeColor.resetColor()
        resetButton.setTitle(I18n.reset, forState: .Normal)
        resetButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        resetButton.titleLabel?.adjustsFontSizeToFitWidth = true
        leftUtilityButtons = [resetButton]
    }
}
