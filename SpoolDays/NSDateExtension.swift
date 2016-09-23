import Foundation
extension Date {
    func dateIntervalFromNow() -> Int {
        return dateIntervalFromDate(Date())
    }

    func dateIntervalFromDate(_ from: Date) -> Int {
        return (self as NSDate).mt_days(until: from)
    }

    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }

    static func fromString(_ str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: str)
    }
}
