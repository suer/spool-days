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
    }

    override func viewWillAppear(animated: Bool) {
        datesViewModel.fetch()
        setSharedDefaults(datesViewModel)
        tableView!.reloadData()
        navigationController?.toolbarHidden = false
        super.viewWillAppear(animated)
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
                self.tableView!.deleteRowsAtIndexPaths([event.indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                break
            default:
                break
            }
            self.tableView!.reloadData()
        })
    }

    func loadEditButton() {
        let editButton = UIBarButtonItem()
        editButton.title = "Edit"
        editButton.rac_command = RACCommand(signalBlock: {
            obj in
            self.tableView!.setEditing(!self.tableView!.editing, animated: true)
            if (self.tableView!.editing) {
                editButton.title = "Finish"
            } else {
                editButton.title = "Edit"
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
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as DateTableViewCell
        showEditView(cell.dateViewModel)
    }

    func showEditView(dateViewModel: DateViewModel) {
        dateViewModel.valueChangeSignal.subscribeNext({
            obj in
            self.tableView?.reloadData()
            return
        })

        let editViewController = EditViewController(dateViewModel: dateViewModel)
        let navigationController = UINavigationController(rootViewController: editViewController)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(navigationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
