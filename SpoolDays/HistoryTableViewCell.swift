import UIKit

class HistoryTableViewCell: UITableViewCell {
    let log: Log
    init(log: Log) {
        self.log = log
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if let date = change["new"] as? NSDate {
            textLabel?.text = Calendar(date: log.date).dateString()
        }
    }
}
