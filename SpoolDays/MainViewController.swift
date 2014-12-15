import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
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

    func loadTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView!.delegate = self
        tableView!.dataSource = datesViewModel
        tableView!.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView!)

        datesViewModel.itemChangedSignal.subscribeNext({
            obj in
            let event = obj as RowsChangeEvent
            switch(event.eventType) {
            case .Delete:
                self.deleteDate(event.indexPath!)
                break
            default:
                break
            }
            self.reload()
        })
    }

    private func deleteDate(indexPath: NSIndexPath) {
        let title = NSLocalizedString("Confirmation", comment: "")
        let message = NSLocalizedString("Are you sure you want to delete?", comment: "")
        let yes = NSLocalizedString("Yes", comment: "")
        let no = NSLocalizedString("No", comment: "")
        let delegate = DeleteConfirmationDelegate(indexPath: indexPath, datesViewModel: datesViewModel, tableView: tableView!)
        if NSClassFromString("UIAlertController") == nil {
            // iOS7
            let alert = UIAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: no, otherButtonTitles: yes)
            alert.show()
            return
        }

        // iOS8
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: no, style: .Default, handler: nil))
        alertController.addAction(UIAlertAction(title: yes, style: .Default, handler: {
            action in
            delegate.deleteBaseDate()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as DateTableViewCell
        showEditView(cell.dateViewModel)
        setSharedDefaults(datesViewModel)
    }

    func showEditView(dateViewModel: DateViewModel) {
        let editViewController = EditViewController(dateViewModel: dateViewModel)
        let navigationController = UINavigationController(rootViewController: editViewController)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(navigationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
