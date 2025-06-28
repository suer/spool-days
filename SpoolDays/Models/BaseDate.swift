import Foundation
import CoreData

@objc(BaseDate)
class BaseDate: NSManagedObject {

    @NSManaged var date: Date
    @NSManaged var sort: NSNumber
    @NSManaged var title: String
    @NSManaged var logs: NSSet

    class func createBaseDate(_ title: String, date: Date) -> BaseDate? {
        let context = CoreDataManager.shared.context

        let fetchRequest: NSFetchRequest<BaseDate> = NSFetchRequest<BaseDate>(entityName: "BaseDate")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1

        let maxSort: Int
        if let lastBaseDate = try? context.fetch(fetchRequest).first {
            maxSort = lastBaseDate.sort.intValue
        } else {
            maxSort = 0
        }

        let baseDate = BaseDate(context: context)
        baseDate.sort = NSNumber(value: maxSort + 1)
        baseDate.date = date
        baseDate.title = title

        let log = Log(context: context)
        log.date = date
        log.duration = 0
        log.baseDate = baseDate
        log.event = "create"

        CoreDataManager.shared.saveAndWait()
        return baseDate
    }

    func update(title: String, date: Date) {
        let context = CoreDataManager.shared.context

        if self.date == date {
            let log = Log(context: context)
            log.date = date
            log.duration = NSNumber(value: dateInterval())
            log.baseDate = self
            log.event = "edit"
        }

        self.title = title
        self.date = date

        CoreDataManager.shared.saveAndWait()
    }

    class func move(fromIndex: Int, toIndex: Int) {
        let context = CoreDataManager.shared.context

        let fetchRequest: NSFetchRequest<BaseDate> = NSFetchRequest<BaseDate>(entityName: "BaseDate")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        guard let dates = try? context.fetch(fetchRequest) else { return }

        dates[fromIndex].sort = NSNumber(value: toIndex)
        if fromIndex < toIndex {
            for i in stride(from: (fromIndex + 1), to: toIndex, by: 1) {
                dates[i].sort = NSNumber(value: dates[i].sort.intValue - 1)
            }
        } else {
            for i in toIndex ..< fromIndex {
                dates[i].sort = NSNumber(value: dates[i].sort.intValue + 1)
            }
        }
        CoreDataManager.shared.saveAndWait()
    }

    func delete() {
        let context = CoreDataManager.shared.context

        if logs.count > 0 {
            for log in logs {
                context.delete(log as! NSManagedObject)
            }
        }
        context.delete(self)
        CoreDataManager.shared.saveAndWait()
    }

    func reset(_ date: Date) {
        let context = CoreDataManager.shared.context

        let log = Log(context: context)
        log.date = date
        log.duration = NSNumber(value: dateInterval(date))
        log.baseDate = self
        log.event = "reset"

        self.date = date
        CoreDataManager.shared.saveAndWait()
    }

    class func first() -> BaseDate? {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<BaseDate> = NSFetchRequest<BaseDate>(entityName: "BaseDate")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1

        return try? context.fetch(fetchRequest).first
    }

    func dateInterval() -> Int {
        return date.dateIntervalFromNow()
    }

    func dateInterval(_ from: Date) -> Int {
        return date.dateIntervalFromDate(from)
    }
}
