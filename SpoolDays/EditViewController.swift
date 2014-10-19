import UIKit

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var textView: UITextView?
    let dateViewModel: DateViewModel
    var tableView: UITableView?

    let textViewHeight = CGFloat(150.0)
    let cellHeight = CGFloat(50.0)

    convenience init (dateViewModel: DateViewModel) {
        self.init(nibName: nil, bundle: nil, dateViewModel: dateViewModel)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
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
        dismissViewControllerAnimated(true, completion: nil)
    }

    func loadTextView() {
        textView = UITextView(frame: CGRectMake(0, 0, view.bounds.width, textViewHeight))
        textView!.text = dateViewModel.title
        textView!.layer.borderWidth = 1
        textView!.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).CGColor
        view.addSubview(textView!)
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
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(date)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
