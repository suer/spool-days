import Foundation
class Calendar {
    let date: NSDate
    init(date: NSDate) {
        self.date = date
    }

    func dateIntervalFromNow() -> Int {
        return dateIntervalFromDate(NSDate())
    }

    func dateIntervalFromDate(from: NSDate) -> Int {
        return date.mt_daysUntilDate(from)
    }

    func dateString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        return dateFormatter.stringFromDate(date)
    }
}