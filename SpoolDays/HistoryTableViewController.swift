import UIKit

class HistoryTableViewController: UITableViewController {
    let historyViewModel: HistoryViewModel
    let dateViewModel: DateViewModel

    init(dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        self.historyViewModel = HistoryViewModel(baseDate: dateViewModel.baseDate!)
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = dateViewModel.getTitle()
        historyViewModel.fetch()
        tableView.reloadData()
        loadCancelButton()
        loadSaveButton()
    }

    // MARK: cancel button

    func loadCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: I18n.cancel, style: UIBarButtonItem.Style.plain, target: self, action: #selector(HistoryTableViewController.cancelButtonTapped))
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: {self.historyViewModel.rollback()})
    }

    // MARK: save button

    func loadSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: I18n.save, style: UIBarButtonItem.Style.plain, target: self, action: #selector(HistoryTableViewController.saveButtonTapped))
    }

    @objc func saveButtonTapped() {
        historyViewModel.save()
        dismiss(animated: true, completion: nil)
    }

    // MARK: table view

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyViewModel.logs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let log = historyViewModel.logs[(indexPath as NSIndexPath).row]
        let cell = HistoryTableViewCell(log: log)
        cell.textLabel?.text = log.dateString()
        cell.detailTextLabel?.text = log.eventString()
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteLog(indexPath)
        }
    }

    fileprivate func deleteLog(_ indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) is HistoryTableViewCell {
            PopupAlertView.confirm(self, message: I18n.translate("Are you sure you want to delete?")) {
                self.historyViewModel.deleteLog((indexPath as NSIndexPath).row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? HistoryTableViewCell {
            let controller = DatePickerViewController(initialDate: cell.date)
            controller.onSelected = {
                cell.date = $0
                self.tableView.reloadData()
            }
            ModalViewController(baseController: self).presentModalViewController(controller)
        }
    }
}
