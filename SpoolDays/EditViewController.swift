import UIKit

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var textField: UITextField?
    let dateViewModel: DateViewModel
    var tableView: UITableView?
    var invisibleDateTextField: UITextField?
    var datePicker: UIDatePicker?

    var titleString: String
    var date: NSDate

    let textFieldHeight = CGFloat(50.0)
    let cellHeight = CGFloat(50.0)
    let datePickerHeight = CGFloat(300.0)

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
        loadDatePicker()
        loadTextField()
    }

    override func viewWillAppear(animated: Bool) {
        textField!.becomeFirstResponder()
    }

    func loadCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelButtonTapped:"))
        navigationItem.leftBarButtonItem = cancelButton
    }

    func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func loadSaveButton() {
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveButtonTapped:"))
        navigationItem.rightBarButtonItem = saveButton
    }

    func saveButtonTapped(sender: AnyObject) {
        dateViewModel.update(title: titleString, date: date)
        dismissViewControllerAnimated(true, completion: nil)
    }

    func loadTextField() {
        textField = UITextField(frame: CGRectMake(0, 0, view.bounds.width, textFieldHeight))
        textField!.text = titleString
        textField!.placeholder = "Title"
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

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        textField!.resignFirstResponder()
        invisibleDateTextField!.resignFirstResponder()
    }

    func loadDatePicker() {
        datePicker = UIDatePicker(frame: CGRectMake(0, view.bounds.height - datePickerHeight, view.bounds.width, datePickerHeight))
        datePicker!.datePickerMode = UIDatePickerMode.Date
        datePicker!.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)

        invisibleDateTextField = UITextField(frame: CGRectMake(0, 0, 0, 0));
        invisibleDateTextField!.inputView = datePicker
        invisibleDateTextField!.inputAccessoryView = datePickerToolBar()
        view.addSubview(invisibleDateTextField!)
    }

    func datePickerToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.translucent = true
        toolbar.tintColor = nil
        toolbar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Plain, target: self, action: "todayButtonTapped:")
        toolbar.setItems([spacer, todayButton], animated: false)
        return toolbar
    }

    func todayButtonTapped(sender: AnyObject) {
        datePicker!.date = NSDate()
        datePickerValueChanged(datePicker!)
    }

    func datePickerValueChanged(datePicker: UIDatePicker) {
        date = datePicker.date

        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        let cell = tableView!.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        cell!.detailTextLabel?.text = dateFormatter.stringFromDate(date)
    }

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
        cell.textLabel.text = "Date"
        let date = dateViewModel.baseDate?.date ?? NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(date ?? NSDate())
        return cell
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textField!.resignFirstResponder()
        invisibleDateTextField!.becomeFirstResponder()
        datePicker!.setDate(date, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
