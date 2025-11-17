import Foundation

extension Date {
    func dateIntervalFromNow() -> Int {
        return dateIntervalFromDate(Date())
    }

    func dateIntervalFromDate(_ from: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: from)
        return components.day ?? 0
    }

    func dateString(locale: Locale = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        dateFormatter.locale = locale
        return dateFormatter.string(from: self)
    }

    static func fromString(_ str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: str)
    }
}
