import UIKit

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    var textView: UITextView?
    let dateViewModel: DateViewModel
    var tableView: UITableView?
    var datePicker: UIDatePicker?

    var titleString: String
    var date: NSDate

    let textViewHeight = CGFloat(150.0)
    let cellHeight = CGFloat(50.0)

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

        loadCancelButton()
        loadSaveButton()
        loadTextView()
        loadTableView()
        loadDatePicker()
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

    func loadTextView() {
        textView = UITextView(frame: CGRectMake(0, 0, view.bounds.width, textViewHeight))
        textView!.text = titleString
        textView!.layer.borderWidth = 1
        textView!.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).CGColor
        textView!.delegate = self
        view.addSubview(textView!)

        textView!.rac_textSignal().subscribeNext({
            text in
            self.titleString = text as? String ?? ""
        })
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        datePicker!.hidden = true
        return true
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for v in view.subviews {
            if !(v is UITextView) {
                textView!.resignFirstResponder()
            }
        }
    }

    func loadDatePicker() {
        datePicker = UIDatePicker(frame: CGRectMake(0, textViewHeight + textViewHeight, view.bounds.width, 200))
        datePicker!.datePickerMode = UIDatePickerMode.Date
        datePicker!.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        datePicker!.hidden = true
        view.addSubview(datePicker!)
    }

    func datePickerValueChanged(datePicker: UIDatePicker) {
        date = datePicker.date
    }

    func loadTableView() {
        tableView = UITableView(frame: CGRectMake(0, textViewHeight, view.bounds.width, cellHeight))
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
        cell.textLabel?.text = "Date"
        let date = dateViewModel.baseDate?.date ?? NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(date ?? NSDate())
        dateViewModel.rac_valuesForKeyPath("date", observer: dateViewModel).subscribeNext({
            obj in
            let date = obj as? NSDate ?? NSDate()
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(date)
            return
        })
        return cell
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        datePicker!.hidden = false
        textView!.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
