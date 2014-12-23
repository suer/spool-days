import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate {
    var tableView: UITableView?
    let datesViewModel = DatesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "Spool Days"
        loadTableView()
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
        if (tableView != nil) {
            reload()
        }
    }

    private func reload() {
        datesViewModel.fetch()
        setSharedDefaults(datesViewModel)
        tableView!.reloadData()
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
        let editButton = UIBarButtonItem()
        editButton.title = NSLocalizedString("Edit", comment: "")
        editButton.rac_command = RACCommand(signalBlock: {
            obj in
            self.tableView!.setEditing(!self.tableView!.editing, animated: true)
            if (self.tableView!.editing) {
                editButton.title = NSLocalizedString("Finish", comment: "")
            } else {
                editButton.title = NSLocalizedString("Edit", comment: "")
                self.setSharedDefaults(self.datesViewModel)
            }
            return RACSignal.empty()
        })
        navigationItem.rightBarButtonItem = editButton
    }

    func editButtonTapped(sender: AnyObject) {
        tableView!.setEditing(!tableView!.editing, animated: true)
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

    func loadTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView!)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesViewModel.dates.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateViewModel = DateViewModel(baseDate: datesViewModel.dates[indexPath.row])
        let cell = DateTableViewCell(reuseIdentifier: "Cell", dateViewModel: dateViewModel)
        cell.delegate = self
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
                self.tableView!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                break
            }
        })
    }

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
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
                self.tableView!.reloadData()
            default:
                break
            }
        })
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as DateTableViewCell
        let menuController = DateMenuViewController(callback: {
            selectedIndex in
            tableView.deselectRowAtIndexPath(indexPath, animated: true)

            switch selectedIndex {
            case 0:
                self.showEditView(cell.dateViewModel)
                break
            case 1:
                self.resetDate(cell)
                break
            case 2:
                self.showHistoryView(cell.dateViewModel)
                break
            default:
                break
            }
            return
        })
        menuController.modalPresentationStyle = .OverCurrentContext
        menuController.modalTransitionStyle = .CrossDissolve
        presentViewController(menuController, animated: true, completion: nil)
        setSharedDefaults(datesViewModel)
    }

    func showEditView(dateViewModel: DateViewModel) {
        let editViewController = EditViewController(dateViewModel: dateViewModel)
        let navigationController = UINavigationController(rootViewController: editViewController)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(navigationController, animated: true, completion: nil)
    }

    func showHistoryView(dateViewModel: DateViewModel) {
        let historyViewController = HistoryTableViewController(dateViewModel: dateViewModel)
        let navigationController = UINavigationController(rootViewController: historyViewController)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(navigationController, animated: true, completion: nil)
    }
}
