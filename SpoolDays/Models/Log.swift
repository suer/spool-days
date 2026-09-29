import CoreData
import Foundation

@objc(Log)
class Log: NSManagedObject {

    @NSManaged var date: Date
    @NSManaged var duration: Int16
    @NSManaged var event: String
    @NSManaged var baseDate: BaseDate

    enum EventType: String {
        case create
        case reset
        case edit
    }

    var eventType: EventType? {
        get { EventType(rawValue: event) }
        set { event = newValue?.rawValue ?? "" }
    }

    static func findResetLogsByBaseDate(_ baseDate: BaseDate) -> [Log] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Log> = NSFetchRequest<Log>(entityName: "Log")
        let predicate = NSPredicate(format: "baseDate = %@ and event in %@", baseDate, [EventType.create.rawValue, EventType.reset.rawValue])
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
        switch eventType {
        case .create:
            return String(localized: .create)
        case .reset:
            return String(localized: .reset)
        case .edit, .none:
            return ""
        }
    }
}
