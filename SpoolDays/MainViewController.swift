import UIKit

class MainViewController: UITableViewController, SWTableViewCellDelegate {
    let datesViewModel = DatesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = I18n.translate("Spool Days")
        datesViewModel.addObserver(self, forKeyPath: "dates", options: .New, context: nil)
        self.addObserver(self, forKeyPath: "editing", options: .New, context: nil)
        loadEditButton()
        loadToolbar()
        addNotificationCenterObserver()
        registerOnSignificantTimeChange()
    }

    override func viewWillAppear(animated: Bool) {
        reload()
        navigationController?.toolbarHidden = false
        super.viewWillAppear(animated)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        switch keyPath {
        case .Some("dates"):
            self.tableView.reloadData()
        case .Some("editing"):
            navigationItem.rightBarButtonItem?.title = editing ? I18n.finish : I18n.edit
        default:
            break
        }
    }

    deinit {
        datesViewModel.removeObserver(self, forKeyPath: "dates")
        self.removeObserver(self, forKeyPath: "editing")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private func addNotificationCenterObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    func applicationDidBecomeActive(notification: NSNotification) {
        reload()
    }

    private func reload() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            dispatch_async(dispatch_get_main_queue(),{
                self.datesViewModel.fetch()
            })
        })
    }

    func loadEditButton() {
        let editButton = UIBarButtonItem(title: I18n.edit, style: .Plain, target: self, action: Selector("editButtonTapped"))
        navigationItem.rightBarButtonItem = editButton
    }

    func editButtonTapped() {
        editing = !editing
    }

    func loadToolbar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addButtonTapped"))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolbarItems = [spacer, addButton]
    }

    func addButtonTapped() {
        let dateViewModel = DateViewModel(baseDate: nil)
        showEditView(dateViewModel)
    }

    // MARK: table view

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesViewModel.dates.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateViewModel = DateViewModel(baseDate: datesViewModel.dates[indexPath.row])
        let cell = DateTableViewCell(reuseIdentifier: "Cell", dateViewModel: dateViewModel)
        cell.delegate = self
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteDate(indexPath)
        }
    }

    private func deleteDate(indexPath: NSIndexPath) {
        PopupAlertView.confirm(self, message: I18n.translate("Are you sure you want to delete?")) {
            self.tableView.beginUpdates()
            self.datesViewModel.deleteDate(indexPath)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        datesViewModel.move(fromIndex: fromIndexPath.row, toIndex: toIndexPath.row)
    }

    func swipeableTableViewCell(cell: SWTableViewCell, didTriggerLeftUtilityButtonWithIndex index: NSInteger) {
        if index != 0 {
            return
        }

        if let dateCell = cell as? DateTableViewCell {
            resetDate(dateCell)
        }
    }

    private func resetDate(cell: DateTableViewCell) {
        PopupAlertView.confirm(self, message: I18n.translate("Are you sure you want to reset date?")) {
            cell.resetDate()
            self.reload()
        }
    }

    private func resetWithDate(cell: DateTableViewCell) {
        let datePicker = DatePickerViewController(initialDate: NSDate())
        datePicker.onSelected = {
            date in
            PopupAlertView.confirm(self, message: I18n.translateWithFormat("Are you sure you want to reset date with %@?", args: date.dateString())) {
                cell.resetDate(date)
                self.reload()
            }
        }
        ModalViewController(baseController: self).presentModalViewController(datePicker)
    }

    let cellActions = [
        DateTableViewCellAction(name: I18n.edit, action: { controller, cell in controller.showEditView(cell.dateViewModel) }),
        DateTableViewCellAction(name: I18n.reset, action: { controller, cell in controller.resetDate(cell) }),
        DateTableViewCellAction(name: I18n.reset_with_date, action: { controller, cell in controller.resetWithDate(cell) }),
        DateTableViewCellAction(name: I18n.history, action: { controller, cell in controller.showHistoryView(cell.dateViewModel) })
    ]

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DateTableViewCell

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: I18n.cancel, style: .Cancel, handler: nil))
        for cellAction in cellActions {
            ac.addAction(UIAlertAction(title: cellAction.name, style: .Default, handler: { _ in
                cellAction.action(self, cell)
            }))
        }
        presentViewController(ac, animated: true, completion: nil)
    }

    private func showEditView(dateViewModel: DateViewModel) {
        ModalViewController(baseController: self).presentModalViewController(EditViewController(dateViewModel: dateViewModel))
    }

    private func showHistoryView(dateViewModel: DateViewModel) {
        ModalViewController(baseController: self).presentModalViewController(HistoryTableViewController(dateViewModel: dateViewModel))
    }

    private func registerOnSignificantTimeChange() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.onSignificantTimeChange = {
                self.reload()
            }
        }
    }
}
