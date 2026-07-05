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

    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter
    }()

    private static let isoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func dateString(locale: Locale = .current) -> String {
        let formatter = Date.shortDateFormatter
        formatter.locale = locale
        return formatter.string(from: self)
    }

    static func fromString(_ str: String) -> Date? {
        return isoDateFormatter.date(from: str)
    }
}
