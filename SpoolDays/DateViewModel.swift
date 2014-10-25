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

    func resetDate() {
        if baseDate == nil {
            return
        }
        baseDate?.date = NSDate()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    func update(#title: String, date: NSDate) {
        if baseDate == nil {
            let sort = BaseDate.MR_numberOfEntities()
            baseDate = BaseDate.MR_createEntity() as BaseDate?
            baseDate?.sort = sort
        }
        BaseDateWrapper(baseDate: baseDate!).update(title: title, date: date)
        baseDate?.title = title
        baseDate?.date = date

        valueChangeSignal.sendNext(self)
    }
}