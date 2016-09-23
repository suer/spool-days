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
        XCTAssertEqual("8/4/81", date.dateString())
    }

    func testFromString() {
        let str = "2014-08-04"
        let date = Date.fromString(str)
        XCTAssertEqual((date! as NSDate).mt_year(), 2014)
        XCTAssertEqual((date! as NSDate).mt_monthOfYear(), 8)
        XCTAssertEqual((date! as NSDate).mt_dayOfMonth(), 4)
    }

    func testFromStringFail() {
        let str = "2014-08-04-"
        let date = Date.fromString(str)
        XCTAssertNil(date)
    }
}
