import UIKit

class MainViewController: UITableViewController, SWTableViewCellDelegate {
    let datesViewModel = DatesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = I18n.translate("Spool Days")
        datesViewModel.addObserver(self, forKeyPath: "dates", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "editing", options: .new, context: nil)
        loadEditButton()
        loadToolbar()
        addNotificationCenterObserver()
        registerOnSignificantTimeChange()
    }

    override func viewWillAppear(_ animated: Bool) {
        reload()
        navigationController?.isToolbarHidden = false
        super.viewWillAppear(animated)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case .some("dates"):
            self.tableView.reloadData()
        case .some("editing"):
            navigationItem.rightBarButtonItem?.title = isEditing ? I18n.finish : I18n.edit
        default:
            break
        }
    }

    deinit {
        datesViewModel.removeObserver(self, forKeyPath: "dates")
        self.removeObserver(self, forKeyPath: "editing")
        NotificationCenter.default.removeObserver(self)
    }

    fileprivate func addNotificationCenterObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        reload()
    }

    fileprivate func reload() {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: {
            DispatchQueue.main.async(execute: {
                self.datesViewModel.fetch()
            })
        })
    }

    func loadEditButton() {
        let editButton = UIBarButtonItem(title: I18n.edit, style: .plain, target: self, action: #selector(MainViewController.editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }

    func editButtonTapped() {
        isEditing = !isEditing
    }

    func loadToolbar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(MainViewController.addButtonTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbarItems = [spacer, addButton]
    }

    func addButtonTapped() {
        let dateViewModel = DateViewModel(baseDate: nil)
        showEditView(dateViewModel)
    }

    // MARK: table view

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesViewModel.dates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateViewModel = DateViewModel(baseDate: datesViewModel.dates[(indexPath as NSIndexPath).row])
        let cell = DateTableViewCell(reuseIdentifier: "Cell", dateViewModel: dateViewModel)
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDate(indexPath)
        }
    }

    fileprivate func deleteDate(_ indexPath: IndexPath) {
        PopupAlertView.confirm(self, message: I18n.translate("Are you sure you want to delete?")) {
            self.tableView.beginUpdates()
            self.datesViewModel.deleteDate(indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        datesViewModel.move(fromIndex: (fromIndexPath as NSIndexPath).row, toIndex: (toIndexPath as NSIndexPath).row)
    }

    func swipeableTableViewCell(_ cell: SWTableViewCell, didTriggerLeftUtilityButtonWith index: NSInteger) {
        if index != 0 {
            return
        }

        if let dateCell = cell as? DateTableViewCell {
            resetDate(dateCell)
        }
    }

    fileprivate func resetDate(_ cell: DateTableViewCell) {
        PopupAlertView.confirm(self, message: I18n.translate("Are you sure you want to reset date?")) {
            cell.resetDate()
            self.reload()
        }
    }

    fileprivate func resetWithDate(_ cell: DateTableViewCell) {
        let datePicker = DatePickerViewController(initialDate: Date())
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DateTableViewCell

        tableView.deselectRow(at: indexPath, animated: true)

        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: I18n.cancel, style: .cancel, handler: nil))
        for cellAction in cellActions {
            ac.addAction(UIAlertAction(title: cellAction.name, style: .default, handler: { _ in
                cellAction.action(self, cell)
            }))
        }
        present(ac, animated: true, completion: nil)
    }

    fileprivate func showEditView(_ dateViewModel: DateViewModel) {
        ModalViewController(baseController: self).presentModalViewController(EditViewController(dateViewModel: dateViewModel))
    }

    fileprivate func showHistoryView(_ dateViewModel: DateViewModel) {
        ModalViewController(baseController: self).presentModalViewController(HistoryTableViewController(dateViewModel: dateViewModel))
    }

    fileprivate func registerOnSignificantTimeChange() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.onSignificantTimeChange = {
                self.reload()
            }
        }
    }
}
