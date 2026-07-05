import Foundation

class GroupData {
    class var userDefaultSuiteName: String { return "group.org.codefirst.SpoolDaysExtension" }
    class var keyOfDates: String { return "dates" }

    class func setDates(_ dates: [BaseDate]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let list = dates.map { baseDate -> [String: Any] in
            return ["title": baseDate.title, "date": dateFormatter.string(from: baseDate.date)]
        }
        let sharedDefaults = UserDefaults(suiteName: userDefaultSuiteName)
        sharedDefaults?.set(list, forKey: keyOfDates)
    }
}
