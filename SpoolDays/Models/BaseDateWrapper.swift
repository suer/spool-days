class BaseDateWrapper: NSObject {
    let baseDate: BaseDate

    init(baseDate: BaseDate) {
        self.baseDate = baseDate
        super.init()
    }

    class func createBaseDate(title: String) -> BaseDate? {
        let date = NSDate()
        let sort = BaseDate.MR_numberOfEntities()
        let baseDate = BaseDate.MR_createEntity() as BaseDate?
        baseDate?.sort = sort
        baseDate?.date = date
        baseDate?.title = title

        let log = Log.MR_createEntity() as Log
        log.date = date
        log.duration = 0
        log.baseDate = baseDate
        log.event = "create"

        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()

        return baseDate
    }

    func update(#title: String, date: NSDate) {
        if baseDate.date != nil && !baseDate.date.isEqualToDate(date) {
            let log = Log.MR_createEntity() as Log
            log.date = baseDate.date
            log.duration = dateInterval()
            log.baseDate = baseDate
            log.event = "edit"
        }

        baseDate.title = title
        baseDate.date = date

        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    class func move(#fromIndex: Int, toIndex: Int) {
        let dates = BaseDate.MR_findAllSortedBy("sort", ascending: true) as [BaseDate]
        dates[fromIndex].sort = toIndex
        if (fromIndex < toIndex) {
            for var i = fromIndex + 1; i <= toIndex; i++ {
                dates[i].sort = Int(dates[i].sort) - 1
            }
        } else {
            for var i = toIndex; i < fromIndex; i++ {
                dates[i].sort = Int(dates[i].sort) + 1
            }
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    func delete() {
        baseDate.MR_deleteEntity()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    func reset() {
        let log = Log.MR_createEntity() as Log
        log.date = NSDate()
        log.duration = dateInterval()
        log.baseDate = baseDate
        log.event = "reset"

        baseDate.date = NSDate()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    class func first() -> BaseDate? {
        return BaseDate.MR_findFirstOrderedByAttribute("sort", ascending: true) as? BaseDate
    }

    func dateInterval() -> Int {
        return Calendar(date: baseDate.date).dateIntervalFromNow()
    }
}