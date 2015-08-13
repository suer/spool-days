import UIKit

class HistoryTableViewCell: UITableViewCell {
    private let log: Log
    init(log: Log) {
        self.log = log
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let date = change?["new"] as? NSDate {
            textLabel?.text = log.date.dateString()
        }
    }

    var date: NSDate {
        get {
            return log.date
        }
        set {
            log.date = newValue
        }
    }
}
