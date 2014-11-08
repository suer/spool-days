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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let log = logs[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel.text = LogWrapper(log: log).dateString()
        return cell
    }
}