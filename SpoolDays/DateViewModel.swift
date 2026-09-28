import Foundation
import Observation

@Observable
class DateViewModel {
    var baseDate: BaseDate?

    init(baseDate: BaseDate?) {
        self.baseDate = baseDate
    }

    func getTitle() -> String? {
        return baseDate?.title
    }

    func resetDate() {
        resetDate(Date())
    }

    func resetDate(_ date: Date) {
        if let baseDate = baseDate {
            baseDate.reset(date)
        }
    }

    func update(title: String, date: Date) {
        if let baseDate = baseDate {
            baseDate.update(title: title, date: date)
        } else {
            _ = BaseDate.createBaseDate(title, date: date)
        }
    }

    func deleteDate() {
        if let baseDate = baseDate {
            baseDate.delete()
        }
    }
}
