import UIKit

class MainViewController: UITableViewController {
    let datesViewModel = DatesViewModel()
    private var datesObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = String(localized: .spoolDays)
        datesObserver = datesViewModel.observe(\.dates, options: .new) { [weak self] _, _ in
            MainActor.assumeIsolated {
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
        navigationItem.rightBarButtonItem = editButtonItem
        loadToolbar()
        addNotificationCenterObserver()
        registerOnSignificantTimeChange()
        updateEmptyState()
    }

    override func viewWillAppear(_ animated: Bool) {
        reload()
        navigationController?.isToolbarHidden = false
        super.viewWillAppear(animated)
    }

    fileprivate func addNotificationCenterObserver() {
        NotificationCenter.default.addObserver(forName: .didSaveOrDeleteDate, object: nil, queue: .main) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.reload()
            }
        }
    }

    fileprivate func reload() {
        datesViewModel.fetch()
    }

    func loadToolbar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MainViewController.addButtonTapped))
        addButton.style = .done
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [spacer, addButton]
    }

    @objc func addButtonTapped() {
        let dateViewModel = DateViewModel(baseDate: nil)
        showEditView(dateViewModel)
    }

    // MARK: empty state

    fileprivate func updateEmptyState() {
        guard datesViewModel.dates.isEmpty else {
            tableView.backgroundView = nil
            return
        }
        var config = UIContentUnavailableConfiguration.empty()
        config.image = UIImage(systemName: "calendar.badge.plus")
        config.imageProperties.tintColor = ThemeColor.baseColor()
        config.text = String(localized: .noDatesYet)
        config.secondaryText = String(localized: .addADateToStartCounting)

        var button = UIButton.Configuration.borderedProminent()
        button.title = String(localized: .addDate)
        button.image = UIImage(systemName: "plus")
        button.imagePadding = 6
        button.cornerStyle = .capsule
        config.button = button
        config.buttonProperties.primaryAction = UIAction { [weak self] _ in
            self?.addButtonTapped()
        }

        tableView.backgroundView = UIContentUnavailableView(configuration: config)
    }

    // MARK: table view

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesViewModel.dates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateViewModel = DateViewModel(baseDate: datesViewModel.dates[indexPath.row])
        return DateTableViewCell(reuseIdentifier: "Cell", dateViewModel: dateViewModel)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDate(indexPath)
        }
    }

    fileprivate func deleteDate(_ indexPath: IndexPath) {
        PopupAlertView.confirm(self, message: String(localized: .areYouSureYouWantToDelete), style: .destructive) {
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
        datesViewModel.move(fromIndex: fromIndexPath.row, toIndex: toIndexPath.row)
    }

    fileprivate func resetDate(_ cell: DateTableViewCell) {
        PopupAlertView.confirm(self, message: String(localized: .areYouSureYouWantToResetDate)) {
            cell.resetDate()
            self.reload()
        }
    }

    fileprivate func resetWithDate(_ cell: DateTableViewCell) {
        let datePicker = DatePickerViewController(initialDate: Date())
        datePicker.onSelected = { date in
            PopupAlertView.confirm(self, message: String(localized: .areYouSureYouWantToResetDateWith(date.dateString()))) {
                cell.resetDate(date)
                self.reload()
            }
        }
        ModalViewController(baseController: self).presentModalViewController(datePicker, .large)
    }

    let cellActions = [
        DateTableViewCellAction(name: String(localized: .edit), action: { controller, cell in controller.showEditView(cell.dateViewModel) }),
        DateTableViewCellAction(name: String(localized: .reset), action: { controller, cell in controller.resetDate(cell) }),
        DateTableViewCellAction(name: String(localized: .resetWithDate), action: { controller, cell in controller.resetWithDate(cell) }),
        DateTableViewCellAction(name: String(localized: .history), action: { controller, cell in controller.showHistoryView(cell.dateViewModel) }),
    ]

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DateTableViewCell

        tableView.deselectRow(at: indexPath, animated: true)

        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: String(localized: .cancel), style: .cancel, handler: nil))
        for cellAction in cellActions {
            ac.addAction(
                UIAlertAction(
                    title: cellAction.name, style: .default,
                    handler: { _ in
                        cellAction.action(self, cell)
                    }))
        }
        present(ac, animated: true, completion: nil)
    }

    fileprivate func showEditView(_ dateViewModel: DateViewModel) {
        ModalViewController(baseController: self).presentModalViewController(EditViewController(dateViewModel: dateViewModel))
    }

    fileprivate func showHistoryView(_ dateViewModel: DateViewModel) {
        ModalViewController(baseController: self).presentModalViewController(HistoryTableViewController(dateViewModel: dateViewModel), .large)
    }

    fileprivate func registerOnSignificantTimeChange() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.onSignificantTimeChange = {
                self.reload()
            }
        }
    }
}
