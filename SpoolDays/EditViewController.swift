import UIKit

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private enum Row {
        case title, date, delete
    }

    let dateViewModel: DateViewModel
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    var titleString: String
    var date: Date {
        didSet {
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }

    init(dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        self.titleString = dateViewModel.baseDate?.title ?? ""
        self.date = dateViewModel.baseDate?.date as Date? ?? Date()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        loadCancelButton()
        loadSaveButton()
        loadTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        focusOnTextField()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        focusOnTextField()
    }

    fileprivate func focusOnTextField() {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell {
            cell.focusOnTextField()
        }
    }

    fileprivate func blurOnTextField() {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell {
            cell.blurOnTextField()
        }
    }

    // MARK: cancel button

    func loadCancelButton() {
        let cancelButton = UIBarButtonItem(title: String(localized: .cancel), style: .plain, target: self, action: #selector(EditViewController.cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: save button

    func loadSaveButton() {
        let saveButton = UIBarButtonItem(title: String(localized: .save), style: .prominent, target: self, action: #selector(EditViewController.saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }

    @objc func saveButtonTapped() {
        dateViewModel.update(title: titleString, date: date)
        NotificationCenter.default.post(name: .didSaveOrDeleteDate, object: nil)
        dismiss(animated: true, completion: nil)
    }

    // MARK: table view

    func loadTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private var sections: [[Row]] {
        return dateViewModel.baseDate == nil ? [[.title, .date]] : [[.title, .date], [.delete]]
    }

    private func row(at indexPath: IndexPath) -> Row {
        return sections[indexPath.section][indexPath.row]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch row(at: indexPath) {
        case .title:
            let cell = TextFieldTableViewCell(
                value: dateViewModel.baseDate?.title ?? "",
                placeHolder: String(localized: .title),
                reuserIdentifier: "Cell")
            cell.valueChanged = { self.titleString = $0 }
            return cell
        case .date:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.setValueContent(text: String(localized: .date), secondaryText: date.dateString())
            return cell
        case .delete:
            return makeDeleteCell()
        }
    }

    fileprivate func makeDeleteCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "DeleteCell")
        var content = UIListContentConfiguration.cell()
        content.text = String(localized: .delete)
        content.textProperties.color = ThemeColor.deleteColor()
        content.textProperties.alignment = .center
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch row(at: indexPath) {
        case .title:
            focusOnTextField()
        case .date:
            blurOnTextField()
            popupDatePicker()
        case .delete:
            confirmDelete()
        }
    }

    fileprivate func popupDatePicker() {
        let controller = DatePickerViewController(initialDate: date)
        controller.onSelected = { self.date = $0 }
        ModalViewController(baseController: self).presentModalViewController(controller)
    }

    // MARK: delete

    fileprivate func confirmDelete() {
        PopupAlertView.confirm(self, message: String(localized: .areYouSureYouWantToDelete), style: .destructive) {
            self.dateViewModel.deleteDate()
            NotificationCenter.default.post(name: .didSaveOrDeleteDate, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
