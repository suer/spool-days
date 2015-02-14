import XCTest

class CalendarTests: XCTestCase {
    func testDateString() {
        let cal = NSCalendar(identifier: NSGregorianCalendar)!
        let date = cal.dateWithEra(1, year: 1981, month: 8, day: 4, hour: 20, minute: 0, second: 0, nanosecond: 0)!
        let calendar = Calendar(date: date)
        println(calendar.dateString())
        XCTAssertEqual("8/4/81", calendar.dateString())
    }
}
