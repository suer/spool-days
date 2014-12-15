import Foundation

class DeleteConfirmationDelegate: NSObject, UIAlertViewDelegate {
    let indexPath: NSIndexPath
    let datesViewModel: DatesViewModel
    let tableView: UITableView

    init(indexPath: NSIndexPath, datesViewModel: DatesViewModel, tableView: UITableView) {
        self.indexPath = indexPath
        self.datesViewModel = datesViewModel
        self.tableView = tableView
        super.init()
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println(buttonIndex)
        if buttonIndex == 1 {
            deleteBaseDate()
        }
    }

    func deleteBaseDate() {
        datesViewModel.deleteDate(indexPath)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
}