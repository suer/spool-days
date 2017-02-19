import Foundation
import CoreData
import MagicalRecord

@objc(BaseDate)
class BaseDate: NSManagedObject {

    @NSManaged var date: Date
    @NSManaged var sort: NSNumber
    @NSManaged var title: String
    @NSManaged var logs: NSSet

    class func createBaseDate(_ title: String, date: Date) -> BaseDate? {
        let maxSort = BaseDate.mr_aggregateOperation("max:", onAttribute: "sort", with: NSPredicate(value: true))
        if let baseDate = BaseDate.mr_createEntity() {
            baseDate.sort = ((maxSort as! Int) + 1) as NSNumber
            baseDate.date = date
            baseDate.title = title

            if let log = Log.mr_createEntity() {
                log.date = date
                log.duration = 0
                log.baseDate = baseDate
                log.event = "create"
            }

            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            return baseDate
        }
        return nil
    }

    func update(title: String, date: Date) {
        if self.date == date {
            if let log = Log.mr_createEntity() {
                log.date = date
                log.duration = NSNumber(value: dateInterval())
                log.baseDate = self
                log.event = "edit"
            }
        }

        self.title = title
        self.date = date

        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    class func move(fromIndex: Int, toIndex: Int) {
        let dates = BaseDate.mr_findAllSorted(by: "sort", ascending: true) as! [BaseDate]
        dates[fromIndex].sort = NSNumber(value: toIndex)
        if (fromIndex < toIndex) {
            for i in stride(from: (fromIndex + 1), to: toIndex, by: 1) {
                dates[i].sort = (Int(dates[i].sort) - 1) as NSNumber
            }
        } else {
            for i in toIndex ..< fromIndex {
                dates[i].sort = (Int(dates[i].sort) + 1) as NSNumber
            }
        }
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    func delete() {
        if logs.count > 0 {
            for log in logs {
                (log as AnyObject).mr_deleteEntity()
            }
        }
        mr_deleteEntity()
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    func reset(_ date: Date) {
        if let log = Log.mr_createEntity() {
            log.date = date
            log.duration = NSNumber(value: dateInterval(date))
            log.baseDate = self
            log.event = "reset"
        }

        self.date = date
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    class func first() -> BaseDate? {
        return BaseDate.mr_findFirstOrdered(byAttribute: "sort", ascending: true)
    }

    func dateInterval() -> Int {
        return date.dateIntervalFromNow()
    }

    func dateInterval(_ from: Date) -> Int {
        return date.dateIntervalFromDate(from)
    }
}
