import CoreData
import Foundation
import Observation

@Observable
class DatesViewModel {
    private(set) var dates: [BaseDate] = []

    func fetch() {
        dates = CoreDataManager.shared.fetchBaseDates()
        GroupData.setDates(dates)
    }

    func deleteDate(_ indexPath: IndexPath) {
        dates[indexPath.row].delete()
        fetch()
    }

    func move(fromIndex: Int, toIndex: Int) {
        BaseDate.move(fromIndex: fromIndex, toIndex: toIndex)
        fetch()
    }
}
