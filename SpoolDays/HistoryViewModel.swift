class HistoryViewModel: NSObject {
    dynamic var logs: [Log]
    let baseDate: BaseDate
    init(baseDate: BaseDate) {
        self.logs = []
        self.baseDate = baseDate
    }

    func fetch() {
        logs = Log.findResetLogsByBaseDate(baseDate)
    }

    func save() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    func deleteLog(index: Int) {
        logs[index].delete()
        logs.removeAtIndex(index)
    }

    func rollback() {
        NSManagedObjectContext.MR_defaultContext().rollback()
    }
}