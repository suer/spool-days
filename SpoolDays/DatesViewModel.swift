import Foundation
import CoreData

class DatesViewModel: NSObject {
    @objc dynamic var dates: [BaseDate] = []

    func fetch() {
        dates = CoreDataManager.shared.fetchBaseDates()
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
