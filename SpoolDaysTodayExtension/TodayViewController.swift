import UIKit
import NotificationCenter

@available(iOSApplicationExtension 10.0, *)
class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {

    let cellHeight = CGFloat(44.0)
    let maxCellNumber = 5
    var tableView: UITableView?
    var dates: [[String: String]] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(TodayViewController.userDefaultsDidChange(_:)),
            name: UserDefaults.didChangeNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width - 10, height: view.bounds.height), style: UITableView.Style.plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        if #available(iOSApplicationExtension 13.0, *) {
            tableView!.layer.backgroundColor = UIColor.systemBackground.cgColor
        } else {
            tableView!.layer.backgroundColor = UIColor.clear.cgColor
        }
        view.addSubview(tableView!)
        dates = GroupData.getDates(maxCellNumber)
        preferredContentSize.height = cellHeight * CGFloat(dates.count)
        extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
    }

    override func viewWillAppear(_ animated: Bool) {
        dates = GroupData.getDates(maxCellNumber)
        preferredContentSize.height = cellHeight * CGFloat(dates.count)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")

        cell.textLabel?.text = dates[(indexPath as NSIndexPath).row]["title"]
        cell.textLabel?.textColor = UIColor.white

        let date = Date.fromString(dates[(indexPath as NSIndexPath).row]["date"]!)!
        let interval = date.dateIntervalFromDate(Date())
        let unit = NSLocalizedString("Days", comment: "")
        cell.detailTextLabel?.text = "\(interval) \(unit)"
        cell.detailTextLabel?.textColor = UIColor.white

        return cell
    }

    @objc func userDefaultsDidChange(_ notification: Notification) {
        dates = GroupData.getDates(maxCellNumber)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = GroupData.appURL {
            extensionContext?.open(url as URL, completionHandler: nil)
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == NCWidgetDisplayMode.compact {
            self.preferredContentSize = maxSize
        } else {
            self.preferredContentSize.height = cellHeight * CGFloat(dates.count)
        }
    }
}
