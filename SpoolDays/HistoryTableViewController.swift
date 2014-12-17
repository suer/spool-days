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
        tableView.dataSource = historyViewModel
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
