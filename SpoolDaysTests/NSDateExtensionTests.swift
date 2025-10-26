import XCTest

class CalendarTests: XCTestCase {
    func testDateIntervalFromDate() {
        let cal = NSCalendar.current
        let date = (cal as NSCalendar).date(era: 1, year: 1981, month: 8, day: 4, hour: 20, minute: 0, second: 0, nanosecond: 0)!

        let from = (cal as NSCalendar).date(era: 1, year: 1981, month: 9, day: 10, hour: 21, minute: 0, second: 0, nanosecond: 0)!

        XCTAssertEqual(37, date.dateIntervalFromDate(from))
    }

    func testDateString() {
        let cal = NSCalendar.current
        let date = (cal as NSCalendar).date(era: 1, year: 1981, month: 8, day: 4, hour: 20, minute: 0, second: 0, nanosecond: 0)!
        XCTAssertEqual("1981/08/04", date.dateString())
    }

    func testFromString() {
        let date = Date.fromString("2014-08-04")
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date!)
        XCTAssertEqual(components.year, 2014)
        XCTAssertEqual(components.month, 8)
        XCTAssertEqual(components.day, 4)
    }

    func testFromStringFail() {
        let str = "2014-08-04-"
        let date = Date.fromString(str)
        XCTAssertNil(date)
    }
}
