class HistoryViewModel: RVMViewModel, UITableViewDataSource {
    private var logs: [Log]
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

    func rollback() {
        NSManagedObjectContext.MR_defaultContext().rollback()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let log = logs[indexPath.row]
        let cell = HistoryTableViewCell(log: log)
        let logWrapper = LogWrapper(log: log)
        cell.textLabel?.text = logWrapper.dateString()
        cell.detailTextLabel?.text = logWrapper.eventString()
        return cell
    }
}