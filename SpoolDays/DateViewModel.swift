class DateViewModel: NSObject {
    dynamic var baseDate: BaseDate?

    init(baseDate: BaseDate?) {
        self.baseDate = baseDate
        super.init()
    }

    func getTitle() -> String? {
        return baseDate?.title
    }

    func getDate() -> Date? {
        return baseDate?.date as Date?
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
            BaseDate.createBaseDate(title, date: date)
        }
    }

    func deleteDate() {
        if let baseDate = baseDate {
            baseDate.delete()
        }
    }
}
