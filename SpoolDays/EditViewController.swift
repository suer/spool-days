import UIKit

class EditViewController: UIViewController {

    var textView: UITextView?
    let dateViewModel: DateViewModel

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
        let textView = UITextView(frame: CGRectMake(0, 0, view.bounds.width, 200))
        textView.text = dateViewModel.title
        view.addSubview(textView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
