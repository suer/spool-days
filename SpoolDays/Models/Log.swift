import Foundation
import CoreData

@objc(Log)
class Log: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var duration: NSNumber
    @NSManaged var event: String
    @NSManaged var baseDate: BaseDate

}
