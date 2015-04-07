import Foundation
extension NSDate {
    func dateIntervalFromNow() -> Int {
        return dateIntervalFromDate(NSDate())
    }

    func dateIntervalFromDate(from: NSDate) -> Int {
        return self.mt_daysUntilDate(from)
    }

    func dateString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        return dateFormatter.stringFromDate(self)
    }

    class func fromString(str: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.dateFromString(str)
    }
}