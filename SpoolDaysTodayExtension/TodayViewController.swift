import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    var dates: [Dictionary<String, String>] = []

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDefaultsDidChange:",
            name: NSUserDefaultsDidChangeNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize.height = 140.0
        tableView = UITableView(frame: CGRectMake(0, 0, view.bounds.width - 100, view.bounds.height), style: UITableViewStyle.Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.layer.backgroundColor = UIColor.clearColor().CGColor
        view.addSubview(tableView!)
        dates = getDates()
    }

    override func viewWillAppear(animated: Bool) {
        dates = getDates()
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.backgroundColor = UIColor.clearColor().CGColor
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.textLabel.text = dates[indexPath.row]["title"]
        cell.textLabel.textColor = UIColor.whiteColor()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(dates[indexPath.row]["date"]!)!
        let timezoneInterval = -NSTimeZone.systemTimeZone().secondsFromGMTForDate(date)
        date.dateByAddingTimeInterval(NSTimeInterval(timezoneInterval))
        cell.detailTextLabel?.text = String(-Int(date.timeIntervalSinceNow / 60 / 60 / 24))
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        return cell
    }

    func userDefaultsDidChange(notification: NSNotification) {
        dates = getDates()
    }

    func getDates() -> [Dictionary<String, String>] {
        let sharedDefaults = NSUserDefaults(suiteName: "group.org.codefirst.SpoolDaysExtension")
        return sharedDefaults?.objectForKey("dates") as? [Dictionary<String, String>] ?? []
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
}
