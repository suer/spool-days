import Foundation

class GroupData {
    class var userDefaultSuiteName: String { return "group.org.codefirst.SpoolDaysExtension" }
    class var keyOfDates: String { return "dates" }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    class func setDates(_ dates: [BaseDate]) {
        let list = dates.map { baseDate -> [String: Any] in
            return ["title": baseDate.title, "date": dateFormatter.string(from: baseDate.date)]
        }
        let sharedDefaults = UserDefaults(suiteName: userDefaultSuiteName)
        sharedDefaults?.set(list, forKey: keyOfDates)
    }
}
