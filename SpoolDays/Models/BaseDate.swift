import Foundation
import CoreData

@objc(BaseDate)
class BaseDate: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var sort: NSNumber
    @NSManaged var title: String
    @NSManaged var logs: NSSet

    class func createBaseDate(title: String, date: NSDate) -> BaseDate? {
        let maxSort = BaseDate.MR_aggregateOperation("max:", onAttribute: "sort", withPredicate: NSPredicate(value: true)).integerValue
        if let baseDate = BaseDate.MR_createEntity() as BaseDate? {
            baseDate.sort = maxSort + 1
            baseDate.date = date
            baseDate.title = title

            let log = Log.MR_createEntity() as Log
            log.date = date
            log.duration = 0
            log.baseDate = baseDate
            log.event = "create"

            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            return baseDate
        }
        return nil
    }

    func update(#title: String, date: NSDate) {
        if self.date.isEqualToDate(date) {
            let log = Log.MR_createEntity() as Log
            log.date = date
            log.duration = dateInterval()
            log.baseDate = self
            log.event = "edit"
        }

        self.title = title
        self.date = date

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
        if logs.count > 0 {
            for log in logs {
                log.MR_deleteEntity()
            }
        }
        MR_deleteEntity()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    func reset(date: NSDate) {
        let log = Log.MR_createEntity() as Log
        log.date = date
        log.duration = dateInterval(date)
        log.baseDate = self
        log.event = "reset"

        self.date = date
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    class func first() -> BaseDate? {
        return BaseDate.MR_findFirstOrderedByAttribute("sort", ascending: true) as? BaseDate
    }

    func dateInterval() -> Int {
        return Calendar(date: date).dateIntervalFromNow()
    }

    func dateInterval(date: NSDate) -> Int {
        return Calendar(date: date).dateIntervalFromDate(date)
    }
}
