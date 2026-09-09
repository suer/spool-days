import UIKit

class HistoryTableViewCell: UITableViewCell {
    fileprivate let log: Log
    init(log: Log) {
        self.log = log
        super.init(style: .default, reuseIdentifier: "Cell")
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configure() {
        setValueContent(text: log.dateString(), secondaryText: log.eventString())
    }

    var date: Date {
        get {
            return log.date as Date
        }
        set {
            log.date = newValue
            configure()
        }
    }
}
