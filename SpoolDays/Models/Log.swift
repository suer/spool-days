import Foundation
import CoreData

@objc(Log)
class Log: NSManagedObject {

    @NSManaged var date: Date
    @NSManaged var duration: NSNumber
    @NSManaged var event: String
    @NSManaged var baseDate: BaseDate

    class func findResetLogsByBaseDate(_ baseDate: BaseDate) -> [Log] {
        let predicate = NSPredicate(format: "baseDate = %@ and event in %@", baseDate, ["create", "reset"])
        return Log.mr_findAllSorted(by: "_pk", ascending: false, with: predicate) as! [Log]
    }

    func dateString() -> String {
        return date.dateString()
    }

    func delete() {
        mr_deleteEntity()
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
