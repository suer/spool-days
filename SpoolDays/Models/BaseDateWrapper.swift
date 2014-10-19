class BaseDateWrapper {
    class func create(title: String, date: NSDate) {
        let baseDate = BaseDate.MR_createEntity() as BaseDate
        baseDate.title = title
        baseDate.date = date
        
        let log = Log.MR_createEntity() as Log
        log.date = date
        log.duration = 0
        log.baseDate = baseDate
        log.event = "create"

        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
}