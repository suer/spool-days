class DateViewModel: NSObject {
    dynamic var baseDate: BaseDate?

    init(baseDate: BaseDate?) {
        self.baseDate = baseDate
        super.init()
    }

    func getTitle() -> String? {
        return baseDate?.title
    }

    func getDate() -> NSDate? {
        return baseDate?.date
    }

    func resetDate() {
        resetDate(NSDate())
    }

    func resetDate(date: NSDate) {
        if let baseDate = baseDate {
            baseDate.reset(date)
        }
    }

    func update(#title: String, date: NSDate) {
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