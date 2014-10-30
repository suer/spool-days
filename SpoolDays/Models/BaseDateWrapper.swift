class BaseDateWrapper: NSObject {
    let baseDate: BaseDate

    init(baseDate: BaseDate) {
        self.baseDate = baseDate
        super.init()
    }

    class func create(title: String, date: NSDate) {
        let baseDate = BaseDate.MR_createEntity() as BaseDate
        baseDate.title = title
        baseDate.date = date
        baseDate.sort = BaseDate.MR_numberOfEntities()
        
        let log = Log.MR_createEntity() as Log
        log.date = date
        log.duration = 0
        log.baseDate = baseDate
        log.event = "create"

        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    class func createEmptyBaseDate() -> BaseDate? {
        let sort = BaseDate.MR_numberOfEntities()
        let baseDate = BaseDate.MR_createEntity() as BaseDate?
        baseDate?.sort = sort
        return baseDate
    }

    func update(#title: String, date: NSDate) {
        if !baseDate.date.isEqualToDate(date) {
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
        log.date = baseDate.date
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
        let localDate = baseDate.date
        let timezoneInterval = -NSTimeZone.systemTimeZone().secondsFromGMTForDate(localDate)
        localDate.dateByAddingTimeInterval(NSTimeInterval(timezoneInterval))
        return -Int(localDate.timeIntervalSinceNow / 60 / 60 / 24)
    }
}