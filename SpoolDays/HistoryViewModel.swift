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
}