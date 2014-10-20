class DatesViewModel: RVMViewModel, UITableViewDataSource  {
    dynamic var dates: [BaseDate] = []

    func fetch() {
        dates = BaseDate.MR_findAllSortedBy("sort", ascending: true) as [BaseDate]
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? DateTableViewCell ?? DateTableViewCell(reuseIdentifier: "Cell")
        cell.dateViewModel.title = dates[indexPath.row].title
        cell.dateViewModel.date = dates[indexPath.row].date
        return cell
    }
}