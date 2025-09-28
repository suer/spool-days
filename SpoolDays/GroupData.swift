import Foundation

class GroupData {
    class var userDefaultSuiteName: String { return "group.org.codefirst.SpoolDaysExtension" }
    class var keyOfDates: String { return "dates" }

    class func setDates(_ dates: [BaseDate]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let list = dates.map { baseDate -> [String: AnyObject] in
            return ["title": baseDate.title as AnyObject, "date": dateFormatter.string(from: baseDate.date as Date) as AnyObject]
        }
        let sharedDefaults = UserDefaults(suiteName: userDefaultSuiteName)
        sharedDefaults?.set(list, forKey: keyOfDates)
        sharedDefaults?.synchronize()
    }
}
