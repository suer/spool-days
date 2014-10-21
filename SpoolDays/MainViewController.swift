import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
    var tableView: UITableView?
    let datesViewModel = DatesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "Spool Days"
        loadTableView()
        loadAddButton()
        loadEditButton()
    }

    override func viewWillAppear(animated: Bool) {
        datesViewModel.fetch()
        super.viewWillAppear(animated)
    }
    
    func loadTableView() {
        let layout = UICollectionViewFlowLayout()
        let width = (view.bounds.width - 30) / 3
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
            case .Move:
                break
            default:
                break
            }
            self.tableView!.reloadData()
        })
    }

    func loadAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addButtonTapped:"))
        navigationItem.rightBarButtonItem = addButton
    }

    func addButtonTapped(sender: AnyObject) {
        let dateViewModel = DateViewModel(baseDate: nil)
        showEditView(dateViewModel)
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
        navigationItem.leftBarButtonItem = editButton
    }

    func editButtonTapped(sender: AnyObject) {
        tableView!.setEditing(!tableView!.editing, animated: true)
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
