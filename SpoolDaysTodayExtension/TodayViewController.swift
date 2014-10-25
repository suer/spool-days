import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize.height = 140.0
        tableView = UITableView(frame: CGRectMake(0, 0, view.bounds.width - 100, view.bounds.height), style: UITableViewStyle.Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.layer.backgroundColor = UIColor.clearColor().CGColor
        view.addSubview(tableView!)
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.backgroundColor = UIColor.clearColor().CGColor
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.textLabel.text = "test"
        cell.textLabel.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.text = "0"
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
}
