class GroupData {
    class var userDefaultSuiteName: String { return "group.org.codefirst.SpoolDaysExtension" }
    class var keyOfDates: String { return "dates" }

    class func setDates(dates: [BaseDate]) {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let list = dates.map {
                (baseDate) -> Dictionary<String, AnyObject> in
                return ["title": baseDate.title, "date": dateFormatter.stringFromDate(baseDate.date)]
            }
            let sharedDefaults = NSUserDefaults(suiteName: userDefaultSuiteName)
            sharedDefaults?.setObject(list, forKey: keyOfDates)
            sharedDefaults?.synchronize()
    }

    class func getDates(count: Int) -> [Dictionary<String, String>] {
        let sharedDefaults = NSUserDefaults(suiteName: userDefaultSuiteName)
        var dates = sharedDefaults?.objectForKey(keyOfDates) as? [Dictionary<String, String>] ?? []
        if dates.count > count {
            dates = Array(dates[0..<count])
        }
        return dates
    }
}
