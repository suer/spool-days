import UIKit

class DateMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let callback: (Int) -> ()
    private let menuNum = 4
    private let cellHeight = 44
    private let bottomMargin = 10
    private var tableView: UITableView?
    init(callback: (Int) -> ()) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
        let tableHeigit = CGFloat(cellHeight * menuNum)
        tableView = UITableView(frame: CGRectMake(0, view.bounds.height - tableHeigit - CGFloat(bottomMargin), view.bounds.width, tableHeigit))
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.scrollEnabled = false
        view.addSubview(tableView!)
        super.viewDidLoad()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNum
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.textColor = ThemeColor.linkColor()
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = NSLocalizedString("Edit", comment: "")
        case 1:
            cell.textLabel?.text = NSLocalizedString("Reset", comment: "")
        case 2:
            cell.textLabel?.text = NSLocalizedString("History", comment: "")
        case 3:
            cell.textLabel?.text = NSLocalizedString("Cancel", comment: "")
        default:
            break
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        dismissViewControllerAnimated(true, completion: {self.callback(indexPath.row)})
    }
}
