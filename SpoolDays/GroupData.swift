import Foundation

enum GroupData {
    static let userDefaultSuiteName = "group.org.codefirst.SpoolDaysExtension"
    static let keyOfDates = "dates"

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func setDates(_ dates: [BaseDate]) {
        let list = dates.map { baseDate -> [String: Any] in
            return ["title": baseDate.title, "date": dateFormatter.string(from: baseDate.date)]
        }
        let sharedDefaults = UserDefaults(suiteName: userDefaultSuiteName)
        sharedDefaults?.set(list, forKey: keyOfDates)
    }
}
