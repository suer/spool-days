class DateViewModel: RVMViewModel {
    var baseDate: BaseDate?
    let valueChangeSignal = RACSubject()

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

    func update(#title: String, date: NSDate) {
        if baseDate == nil {
            baseDate = BaseDate.MR_createEntity() as BaseDate?
        }
        BaseDateWrapper(baseDate: baseDate!).update(title: title, date: date)
        baseDate?.title = title
        baseDate?.date = date
        valueChangeSignal.sendNext(self)
    }
}