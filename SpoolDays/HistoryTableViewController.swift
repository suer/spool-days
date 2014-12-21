import UIKit

class HistoryTableViewController: UITableViewController {
    let historyViewModel: HistoryViewModel
    let dateViewModel: DateViewModel

    convenience init(dateViewModel: DateViewModel) {
        self.init(nibName: nil, bundle: nil, dateViewModel: dateViewModel)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        self.historyViewModel = HistoryViewModel(baseDate: dateViewModel.baseDate!)
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Reset History", comment: "")
        historyViewModel.fetch()
        tableView.reloadData()
        loadCancelButton()
        loadSaveButton()
    }

    func loadCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment:""), style: UIBarButtonItemStyle.Plain, target: self, action: "cancelButtonTapped")
    }

    func cancelButtonTapped() {
        dismissViewControllerAnimated(true, completion: {self.historyViewModel.rollback()})
    }

    func loadSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment:""), style: UIBarButtonItemStyle.Plain, target: self, action: "saveButtonTapped")
    }

    func saveButtonTapped() {
        historyViewModel.save()
        dismissViewControllerAnimated(true, completion: nil)
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyViewModel.logs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let log = historyViewModel.logs[indexPath.row]
        let cell = HistoryTableViewCell(log: log)
        let logWrapper = LogWrapper(log: log)
        cell.textLabel?.text = logWrapper.dateString()
        cell.detailTextLabel?.text = logWrapper.eventString()
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteLog(indexPath)
        }
    }

    private func deleteLog(indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? HistoryTableViewCell {
            let title = NSLocalizedString("Confirmation", comment: "")
            let message = NSLocalizedString("Are you sure you want to delete?", comment: "")
            let yes = NSLocalizedString("Yes", comment: "")
            let no = NSLocalizedString("No", comment: "")
            RMUniversalAlert.showAlertInViewController(self, withTitle: title, message: message, cancelButtonTitle: no, destructiveButtonTitle: nil, otherButtonTitles: [yes], tapBlock: {
                buttonIndex in
                switch buttonIndex {
                case UIAlertControllerBlocksFirstOtherButtonIndex:
                    self.historyViewModel.deleteLog(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                default:
                    break
                }
            })
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? HistoryTableViewCell {
            let controller = DatePickerViewController(initialDate: cell.log.date, {
                date in
                cell.log.date = date
                self.tableView.reloadData()
            })
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            presentViewController(navigationController, animated: true, completion: nil)
        }
    }
}
