class LogWrapper: NSObject {
    let log: Log
    init(log: Log) {
        self.log = log
    }

    class func findByBaseDate(baseDate: BaseDate) -> [Log] {
        let predicate = NSPredicate(format: "baseDate = %@", baseDate)
        return Log.MR_findAllSortedBy("_pk", ascending: true, withPredicate: predicate) as [Log]
    }
}