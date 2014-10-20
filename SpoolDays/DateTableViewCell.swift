import UIKit

class DateTableViewCell: UITableViewCell {
    var dateViewModel: DateViewModel

    init(reuseIdentifier: String?) {
        dateViewModel = DateViewModel()
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        loadCountLabel()
        loadTitleLabel()
    }

    required init(coder aDecoder: NSCoder) {
        dateViewModel = DateViewModel()
        super.init(coder: aDecoder)
    }

    func loadCountLabel() {
        dateViewModel.rac_valuesForKeyPath("date", observer: dateViewModel).subscribeNext({
            obj in
            if obj == nil {
                return
            }
            let date = obj as NSDate
            let dateInterval = Int(date.timeIntervalSinceNow / 60 / 60 / 24)
            self.detailTextLabel?.text = "\(-dateInterval)"
            return
        })
    }

    func loadTitleLabel() {
        dateViewModel.rac_valuesForKeyPath("title", observer: dateViewModel).subscribeNext({
            obj in
            if obj == nil {
                return
            }
            let title = obj as String
            self.textLabel?.text = title
            return
        })
    }
}
