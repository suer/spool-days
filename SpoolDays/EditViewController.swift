import UIKit

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let cellCount = 2

    let dateViewModel: DateViewModel
    var tableView: UITableView?

    var titleString: String
    var date: NSDate {
        didSet {
            if let cell = tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) {
                cell.detailTextLabel?.text = date.dateString()
            }
        }
    }

    let cellHeight = CGFloat(50.0)
    let showLogButtonHeight = CGFloat(50.0)

    convenience init (dateViewModel: DateViewModel) {
        self.init(nibName: nil, bundle: nil, dateViewModel: dateViewModel)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        self.titleString = dateViewModel.baseDate?.title ?? ""
        self.date = dateViewModel.baseDate?.date ?? NSDate()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false

        loadCancelButton()
        loadSaveButton()
        loadTableView()
        loadDeleteButon()
    }

    override func viewDidAppear(animated: Bool) {
        focusOnTextField()
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        focusOnTextField()
    }

    private func focusOnTextField() {
        if let cell = tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TextFieldTableViewCell {
            cell.focusOnTextField()
        }
    }

    private func blurOnTextField() {
        if let cell = tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TextFieldTableViewCell {
            cell.blurOnTextField()
        }
    }

    // MARK: cancel button

    func loadCancelButton() {
        let cancelButton = UIBarButtonItem(title: I18n.cancel, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelButtonTapped:"))
        navigationItem.leftBarButtonItem = cancelButton
    }

    func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: save button

    func loadSaveButton() {
        let saveButton = UIBarButtonItem(title: I18n.save, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveButtonTapped:"))
        navigationItem.rightBarButtonItem = saveButton
    }

    func saveButtonTapped(sender: AnyObject) {
        dateViewModel.update(title: titleString, date: date)
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: table view

    func loadTableView() {
        tableView = UITableView()
        tableView!.delegate = self
        tableView!.dataSource = self
        view.addSubview(tableView!)

        tableView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        view!.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        let topConstraint = NSLayoutConstraint(item: tableView!, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: tableView!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: cellHeight * CGFloat(cellCount))
        let leftConstraint = NSLayoutConstraint(item: tableView!, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: tableView!, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        view!.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])

    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = TextFieldTableViewCell(value: dateViewModel.baseDate?.title ?? "", placeHolder: "Title", reuserIdentifier: "Cell")
            cell.valueChanged = { self.titleString = $0 }
            return cell
        } else {
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
            cell.textLabel?.text = I18n.translate("Date")
            cell.detailTextLabel?.text = (dateViewModel.baseDate?.date ?? NSDate()).dateString()
            return cell
        }
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            focusOnTextField()
        } else {
            blurOnTextField()
            popupDatePicker()
        }
    }

    private func popupDatePicker() {
        let controller = DatePickerViewController(initialDate: date)
        controller.onSelected = {
            date in
            self.date = date
        }
        ModalViewController(baseController: self).presentModalViewController(controller)
    }

    // MARK: delete button

    func loadDeleteButon() {
        if dateViewModel.baseDate == nil {
            return
        }
        let deleteButton = UIButton(frame: CGRectMake(0, cellHeight * CGFloat(cellCount + 1), view.bounds.width, cellHeight))
        deleteButton.backgroundColor = ThemeColor.deleteColor()
        deleteButton.setTitle(I18n.delete, forState: .Normal)
        deleteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        view.addSubview(deleteButton)

        deleteButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        view!.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        let topConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: cellHeight * CGFloat(cellCount + 1))
        let bottomConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: cellHeight * CGFloat(cellCount + 2))
        let leftConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: deleteButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        view!.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])

        deleteButton.addTarget(self, action: Selector("deleteButtonTapped"), forControlEvents: .TouchUpInside)
    }

    func deleteButtonTapped() {
        RMUniversalAlert.showAlertInViewController(self,
            withTitle: I18n.translate("Are you sure you want to delete?"),
            message: nil,
            cancelButtonTitle: I18n.cancel,
            destructiveButtonTitle: nil,
            otherButtonTitles: [I18n.yes],
            tapBlock: {
                (alert, index) in
                switch index {
                case alert.firstOtherButtonIndex:
                    self.dateViewModel.deleteDate()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    break
                default:
                    break
                }
                return
        })
    }
}
