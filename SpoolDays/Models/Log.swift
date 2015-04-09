import Foundation
import CoreData

@objc(Log)
class Log: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var duration: NSNumber
    @NSManaged var event: String
    @NSManaged var baseDate: BaseDate

    class func findResetLogsByBaseDate(baseDate: BaseDate) -> [Log] {
        let predicate = NSPredicate(format: "baseDate = %@ and event in %@", baseDate, ["create", "reset"])
        return Log.MR_findAllSortedBy("_pk", ascending: false, withPredicate: predicate) as! [Log]
    }

    func dateString() -> String {
        return date.dateString()
    }

    func delete() {
        MR_deleteEntity()
    }

    func eventString() -> String {
        switch(event) {
        case "create":
            return I18n.create
        case "reset":
            return I18n.reset
        default:
            return ""
        }
    }
}
