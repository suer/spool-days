import Foundation

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
        CoreDataManager.shared.saveAndWait()
    }

    func deleteLog(_ index: Int) {
        logs[index].delete()
        logs.remove(at: index)
    }

    func rollback() {
        CoreDataManager.shared.rollback()
    }
}
