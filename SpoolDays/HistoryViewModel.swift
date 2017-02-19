import Foundation
import MagicalRecord

class HistoryViewModel: NSObject {
    dynamic var logs = [Log]()
    let baseDate: BaseDate
    init(baseDate: BaseDate) {
        self.baseDate = baseDate
    }

    func fetch() {
        logs = Log.findResetLogsByBaseDate(baseDate)
    }

    func save() {
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    func deleteLog(_ index: Int) {
        logs[index].delete()
        logs.remove(at: index)
    }

    func rollback() {
        NSManagedObjectContext.mr_default().rollback()
    }
}
