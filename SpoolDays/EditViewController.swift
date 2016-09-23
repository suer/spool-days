import UIKit

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let cellCount = 2

    let dateViewModel: DateViewModel
    var tableView: UITableView?

    var titleString: String
    var date: Date {
        didSet {
            if let cell = tableView?.cellForRow(at: IndexPath(row: 1, section: 0)) {
                cell.detailTextLabel?.text = date.dateString()
            }
        }
    }

    let cellHeight = CGFloat(50.0)
    let showLogButtonHeight = CGFloat(50.0)

    convenience init (dateViewModel: DateViewModel) {
        self.init(nibName: nil, bundle: nil, dateViewModel: dateViewModel)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        self.titleString = dateViewModel.baseDate?.title ?? ""
        self.date = dateViewModel.baseDate?.date as Date? ?? Date()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        automaticallyAdjustsScrollViewInsets = false

        loadCancelButton()
        loadSaveButton()
        loadTableView()
        loadDeleteButon()
    }

    override func viewDidAppear(_ animated: Bool) {
        focusOnTextField()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        focusOnTextField()
    }

    fileprivate func focusOnTextField() {
        if let cell = tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell {
            cell.focusOnTextField()
        }
    }

    fileprivate func blurOnTextField() {
        if let cell = tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell {
            cell.blurOnTextField()
        }
    }

    // MARK: cancel button

    func loadCancelButton() {
        let cancelButton = UIBarButtonItem(title: I18n.cancel, style: UIBarButtonItemStyle.plain, target: self, action: #selector(EditViewController.cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }

    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: save button

    func loadSaveButton() {
        let saveButton = UIBarButtonItem(title: I18n.save, style: UIBarButtonItemStyle.plain, target: self, action: #selector(EditViewController.saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }

    func saveButtonTapped() {
        dateViewModel.update(title: titleString, date: date)
        dismiss(animated: true, completion: nil)
    }

    // MARK: table view

    func loadTableView() {
        tableView = UITableView()
        tableView!.delegate = self
        tableView!.dataSource = self
        view.addSubview(tableView!)

        tableView!.translatesAutoresizingMaskIntoConstraints = false
        view!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let topConstraint = NSLayoutConstraint(item: tableView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: tableView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: cellHeight * CGFloat(cellCount))
        let leftConstraint = NSLayoutConstraint(item: tableView!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: tableView!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0)
        view!.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row == 0 {
            let cell = TextFieldTableViewCell(value: dateViewModel.baseDate?.title ?? "", placeHolder: "Title", reuserIdentifier: "Cell")
            cell.valueChanged = { self.titleString = $0 }
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.textLabel?.text = I18n.translate("Date")
            cell.detailTextLabel?.text = (dateViewModel.baseDate?.date ?? Date()).dateString()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath as NSIndexPath).row == 0 {
            focusOnTextField()
        } else {
            blurOnTextField()
            popupDatePicker()
        }
    }

    fileprivate func popupDatePicker() {
        let controller = DatePickerViewController(initialDate: date)
        controller.onSelected = { self.date = $0 }
        ModalViewController(baseController: self).presentModalViewController(controller)
    }

    // MARK: delete button

    func loadDeleteButon() {
        if dateViewModel.baseDate == nil {
            return
        }
        let deleteButton = UIButton(frame: CGRect(x: 0, y: cellHeight * CGFloat(cellCount + 1), width: view.bounds.width, height: cellHeight))
        deleteButton.backgroundColor = ThemeColor.deleteColor()
        deleteButton.setTitle(I18n.delete, for: UIControlState())
        deleteButton.setTitleColor(UIColor.white, for: UIControlState())
        view.addSubview(deleteButton)

        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        view!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let topConstraint = NSLayoutConstraint(item: deleteButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: cellHeight * CGFloat(cellCount + 1))
        let bottomConstraint = NSLayoutConstraint(item: deleteButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: cellHeight * CGFloat(cellCount + 2))
        let leftConstraint = NSLayoutConstraint(item: deleteButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: deleteButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0)
        view!.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])

        deleteButton.addTarget(self, action: #selector(EditViewController.deleteButtonTapped), for: .touchUpInside)
    }

    func deleteButtonTapped() {
        PopupAlertView.confirm(self, message: I18n.translate("Are you sure you want to delete?")) {
            self.dateViewModel.deleteDate()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
