import UIKit

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var textField: UITextField?
    let dateViewModel: DateViewModel
    var tableView: UITableView?

    var titleString: String
    var date: NSDate {
        didSet {
            if let cell = tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) {
                cell.detailTextLabel?.text = Calendar(date: date).dateString()
            }
        }
    }

    let textFieldHeight = CGFloat(50.0)
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
        loadTextField()
        if dateViewModel.baseDate != nil {
            loadShowLogButton()
        }
    }

    override func viewWillAppear(animated: Bool) {
        textField!.becomeFirstResponder()
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        textField!.resignFirstResponder()
    }

    // MARK: cancel button

    func loadCancelButton() {
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelButtonTapped:"))
        navigationItem.leftBarButtonItem = cancelButton
    }

    func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: save button

    func loadSaveButton() {
        let saveButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveButtonTapped:"))
        navigationItem.rightBarButtonItem = saveButton
    }

    func saveButtonTapped(sender: AnyObject) {
        dateViewModel.update(title: titleString, date: date)
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: text field

    func loadTextField() {
        textField = UITextField(frame: CGRectMake(0, 0, view.bounds.width, textFieldHeight))
        textField!.text = titleString
        textField!.placeholder = NSLocalizedString("Title", comment: "")
        textField!.font = UIFont.systemFontOfSize(16)
        textField!.leftView = UIView(frame: CGRectMake(0, 0, 15, textField!.frame.size.height))
        textField!.leftViewMode = UITextFieldViewMode.Always
        textField!.layer.borderWidth = 1
        textField!.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).CGColor
        textField!.delegate = self
        view.addSubview(textField!)

        textField!.rac_textSignal().subscribeNext({
            text in
            self.titleString = text as? String ?? ""
        })
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }

    // MARK: show log button

    func loadShowLogButton() {
        let button = UIButton(frame: CGRectMake(0, textFieldHeight + cellHeight, view.bounds.width, showLogButtonHeight))
        button.setTitle(NSLocalizedString("Show Reset History", comment: ""), forState: UIControlState.Normal)
        button.setTitleColor(ThemeColor.linkColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor(white: 0.7, alpha: 1.0), forState: UIControlState.Highlighted)
        view.addSubview(button)

        button.rac_command = RACCommand(signalBlock: {
            obj in
            let controller = HistoryTableViewController(dateViewModel: self.dateViewModel)
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(navigationController, animated: true, completion: nil)
            return RACSignal.empty()
        })
    }

    // MARK: table view

    func loadTableView() {
        tableView = UITableView(frame: CGRectMake(0, textFieldHeight, view.bounds.width, cellHeight))
        tableView!.delegate = self
        tableView!.dataSource = self
        view.addSubview(tableView!)
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = NSLocalizedString("Date", comment: "")
        cell.detailTextLabel?.text = Calendar(date: dateViewModel.baseDate?.date ?? NSDate()).dateString()
        return cell
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textField!.resignFirstResponder()
        let controller = DatePickerViewController(initialDate: date, {
            date in
            self.date = date
        })
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(navigationController, animated: true, completion: nil)
    }
}
