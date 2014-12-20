class DatesViewModel: RVMViewModel {
    dynamic var dates: [BaseDate] = []

    func fetch() {
        dates = BaseDate.MR_findAllSortedBy("sort", ascending: true) as [BaseDate]
    }

    func deleteDate(indexPath: NSIndexPath) {
        BaseDateWrapper(baseDate: dates[indexPath.row]).delete()
        fetch()
    }
}