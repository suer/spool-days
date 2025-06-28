import Foundation
import CoreData

@objc(Log)
class Log: NSManagedObject {

    @NSManaged var date: Date
    @NSManaged var duration: NSNumber
    @NSManaged var event: String
    @NSManaged var baseDate: BaseDate

    class func findResetLogsByBaseDate(_ baseDate: BaseDate) -> [Log] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Log> = NSFetchRequest<Log>(entityName: "Log")
        let predicate = NSPredicate(format: "baseDate = %@ and event in %@", baseDate, ["create", "reset"])
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "objectID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        return (try? context.fetch(fetchRequest)) ?? []
    }

    func dateString() -> String {
        return date.dateString()
    }

    func delete() {
        let context = CoreDataManager.shared.context
        context.delete(self)
    }

    func eventString() -> String {
        switch event {
        case "create":
            return I18n.create
        case "reset":
            return I18n.reset
        default:
            return ""
        }
    }
}
