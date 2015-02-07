class Calendar {
    let date: NSDate
    init(date: NSDate) {
        self.date = date
    }

    func dateIntervalFromNow() -> Int {
        return dateIntervalFromDate(NSDate())
    }

    func dateIntervalFromDate(from: NSDate) -> Int {
        let unit = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit
        let calendar = NSCalendar(identifier: NSGregorianCalendar) ?? NSCalendar()
        let fromComponent = calendar.dateFromComponents(calendar.components(unit, fromDate: date)) ?? NSDate()
        let toComponent = calendar.dateFromComponents(calendar.components(unit, fromDate: from)) ?? NSDate()
        let components = calendar.components(NSCalendarUnit.DayCalendarUnit, fromDate: fromComponent, toDate: toComponent, options: nil)
        return components.day
    }

    func dateString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        return dateFormatter.stringFromDate(date)
    }
}