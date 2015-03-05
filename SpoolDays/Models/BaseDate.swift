import Foundation
import CoreData

@objc(BaseDate)
class BaseDate: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var sort: NSNumber
    @NSManaged var title: String
    @NSManaged var logs: NSSet

}
