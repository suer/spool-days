import UIKit

class HistoryTableViewCell: UITableViewCell {
    fileprivate let log: Log
    init(log: Log) {
        self.log = log
        super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard change?[.newKey] is Date else { return }
        MainActor.assumeIsolated {
            textLabel?.text = log.date.dateString()
        }
    }

    var date: Date {
        get {
            return log.date as Date
        }
        set {
            log.date = newValue
        }
    }
}
