import Foundation

class DatesViewModel: NSObject {
    dynamic var dates: [BaseDate] = []

    func fetch() {
        dates = BaseDate.mr_findAllSorted(by: "sort", ascending: true) as! [BaseDate]
        GroupData.setDates(dates)
    }

    func deleteDate(_ indexPath: IndexPath) {
        dates[(indexPath as NSIndexPath).row].delete()
        fetch()
    }

    func move(fromIndex: Int, toIndex: Int) {
        BaseDate.move(fromIndex: fromIndex, toIndex: toIndex)
        fetch()
    }
}
