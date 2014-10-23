import UIKit

class DateTableViewCell: UITableViewCell {
    var dateViewModel: DateViewModel

    init(reuseIdentifier: String?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        setupHandler()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHandler() {
        dateViewModel.rac_valuesForKeyPath("baseDate", observer: dateViewModel).subscribeNext({
            obj in
            self.updateLabels()
        })
        dateViewModel.valueChangeSignal.subscribeNext({
            obj in
            self.updateLabels()
        })
    }

    private func updateLabels() {
        textLabel.text = dateViewModel.baseDate?.title
        let date = dateViewModel.baseDate?.date ?? NSDate()
        let dateInterval = Int(date.timeIntervalSinceNow / 60 / 60 / 24)
        detailTextLabel?.text = "\(-dateInterval)"
    }
}
