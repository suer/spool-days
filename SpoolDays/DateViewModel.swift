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
        if baseDate == nil {
            return
        }
        BaseDateWrapper(baseDate: baseDate!).reset(date)
    }

    func update(#title: String, date: NSDate) {
        if baseDate == nil {
            BaseDateWrapper.createBaseDate(title, date: date)
        } else {
            BaseDateWrapper(baseDate: baseDate!).update(title: title, date: date)
        }
    }

    func deleteDate() {
        BaseDateWrapper(baseDate: baseDate!).delete()
    }
}