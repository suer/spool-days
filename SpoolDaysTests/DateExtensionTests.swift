import Foundation
import Testing

struct CalendarTests {
    @Test func dateIntervalFromDate() {
        let cal = NSCalendar.current
        let date = (cal as NSCalendar).date(era: 1, year: 1981, month: 8, day: 4, hour: 20, minute: 0, second: 0, nanosecond: 0)!
        let from = (cal as NSCalendar).date(era: 1, year: 1981, month: 9, day: 10, hour: 21, minute: 0, second: 0, nanosecond: 0)!
        #expect(date.dateIntervalFromDate(from) == 37)
    }

    @Test func dateString() {
        let cal = NSCalendar.current
        let date = (cal as NSCalendar).date(era: 1, year: 1981, month: 8, day: 4, hour: 20, minute: 0, second: 0, nanosecond: 0)!
        #expect(date.dateString(locale: Locale(identifier: "en_US_POSIX")) == "8/4/81")
    }

    @Test func fromString() {
        let date = Date.fromString("2014-08-04")
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date!)
        #expect(components.year == 2014)
        #expect(components.month == 8)
        #expect(components.day == 4)
    }

    @Test func fromStringFail() {
        let date = Date.fromString("2014-08-04-")
        #expect(date == nil)
    }
}
