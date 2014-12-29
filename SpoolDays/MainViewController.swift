import UIKit

class MainViewController: UITableViewController, SWTableViewCellDelegate {
    let datesViewModel = DatesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "Spool Days"
        loadEditButton()
        loadToolbar()
        addNotificationCenterObserver()
    }

    override func viewWillAppear(animated: Bool) {
        reload()
        navigationController?.toolbarHidden = false
        super.viewWillAppear(animated)        
    }

    deinit {
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
                self.setSharedDefaults(self.datesViewModel)
                self.tableView.reloadData()
            })
        })
    }

    func setSharedDefaults(datesViewModel: DatesViewModel) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let list = datesViewModel.dates.map({
            (baseDate) -> Dictionary<String, AnyObject> in
            return ["title": baseDate.title, "date": dateFormatter.stringFromDate(baseDate.date)]
        })
        let sharedDefaults = NSUserDefaults(suiteName: "group.org.codefirst.SpoolDaysExtension")
        sharedDefaults?.setObject(list, forKey: "dates")
        sharedDefaults?.synchronize()
    }

    func loadEditButton() {
        let editButton = UIBarButtonItem(title: NSLocalizedString("Edit", comment: ""), style: .Plain, target: self, action: Selector("editButtonTapped:"))
        navigationItem.rightBarButtonItem = editButton
    }

    func editButtonTapped(button: UIBarButtonItem) {
        self.tableView.setEditing(!tableView.editing, animated: true)
        if (tableView.editing) {
            button.title = NSLocalizedString("Finish", comment: "")
        } else {
            button.title = NSLocalizedString("Edit", comment: "")
            setSharedDefaults(datesViewModel)
        }
    }

    func loadToolbar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addButtonTapped:"))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolbarItems = [spacer, addButton]
    }

    func addButtonTapped(sender: AnyObject) {
        let dateViewModel = DateViewModel(baseDate: nil)
        showEditView(dateViewModel)
        setSharedDefaults(datesViewModel)
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
        let title = NSLocalizedString("Confirmation", comment: "")
        let message = NSLocalizedString("Are you sure you want to delete?", comment: "")
        let yes = NSLocalizedString("Yes", comment: "")
        let no = NSLocalizedString("No", comment: "")
        RMUniversalAlert.showAlertInViewController(self, withTitle: title, message: message, cancelButtonTitle: no, destructiveButtonTitle: nil, otherButtonTitles: [yes], tapBlock: {
            buttonIndex in
            switch buttonIndex {
            case UIAlertControllerBlocksFirstOtherButtonIndex:
                self.datesViewModel.deleteDate(indexPath)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                break
            }
        })
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        BaseDateWrapper.move(fromIndex: fromIndexPath.row, toIndex: toIndexPath.row)
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
        let title = NSLocalizedString("Confirmation", comment: "")
        let message = NSLocalizedString("Are you sure you want to reset date?", comment: "")
        let yes = NSLocalizedString("Yes", comment: "")
        let no = NSLocalizedString("No", comment: "")
        RMUniversalAlert.showAlertInViewController(self, withTitle: title, message: message, cancelButtonTitle: no, destructiveButtonTitle: nil, otherButtonTitles: [yes], tapBlock: {
            buttonIndex in
            switch buttonIndex {
            case UIAlertControllerBlocksFirstOtherButtonIndex:
                cell.resetDate()
                self.reload()
            default:
                break
            }
        })
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as DateTableViewCell
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let otherButtonTitles = [NSLocalizedString("Edit", comment: ""), NSLocalizedString("Reset", comment: ""),NSLocalizedString("History", comment: "")]
        RMUniversalAlert.showActionSheetInViewController(self,
            withTitle: nil,
            message: nil,
            cancelButtonTitle: cancelButtonTitle,
            destructiveButtonTitle: nil,
            otherButtonTitles: otherButtonTitles) {
                index in
                switch index {
                case UIAlertControllerBlocksFirstOtherButtonIndex:
                    self.showEditView(cell.dateViewModel)
                case UIAlertControllerBlocksFirstOtherButtonIndex + 1:
                    self.resetDate(cell)
                case UIAlertControllerBlocksFirstOtherButtonIndex + 2:
                    self.showHistoryView(cell.dateViewModel)
                default:
                    break
                }
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                return
        }
        setSharedDefaults(datesViewModel)
    }

    private func showEditView(dateViewModel: DateViewModel) {
        ModalViewController(baseController: self).presentModalViewController(EditViewController(dateViewModel: dateViewModel))
    }

    private func showHistoryView(dateViewModel: DateViewModel) {
        ModalViewController(baseController: self).presentModalViewController(HistoryTableViewController(dateViewModel: dateViewModel))
    }
}
