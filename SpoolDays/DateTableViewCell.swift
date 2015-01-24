import UIKit

class DateTableViewCell: SWTableViewCell {
    var dateViewModel: DateViewModel

    init(reuseIdentifier: String?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        loadButtons()
        updateLabels()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resetDate() {
        dateViewModel.resetDate()
    }

    private func updateLabels() {
        if let baseDate = dateViewModel.baseDate {
            textLabel?.text = baseDate.title
            let dateInterval = BaseDateWrapper(baseDate: baseDate).dateInterval()
            detailTextLabel?.text = "\(dateInterval) " + I18n.translate("Days")
        }
    }

    private func loadButtons() {
        let leftButtons = NSMutableArray()
        leftButtons.sw_addUtilityButtonWithColor(ThemeColor.resetColor(), title: I18n.reset)
        leftUtilityButtons = leftButtons
    }
}
