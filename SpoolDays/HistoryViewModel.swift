class HistoryViewModel: RVMViewModel {
    var logs: [Log]
    let baseDate: BaseDate
    init(baseDate: BaseDate) {
        self.logs = []
        self.baseDate = baseDate
    }

    func fetch() {
        logs = LogWrapper.findResetLogsByBaseDate(baseDate)
    }

    func save() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    func deleteLog(index: Int) {
        LogWrapper(log:logs[index]).delete()
        logs.removeAtIndex(index)
    }

    func rollback() {
        NSManagedObjectContext.MR_defaultContext().rollback()
    }
}