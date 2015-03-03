class DatesViewModel: NSObject {
    dynamic var dates: [BaseDate] = []

    func fetch() {
        dates = BaseDate.MR_findAllSortedBy("sort", ascending: true) as [BaseDate]
        GroupData.setDates(dates)
    }

    func deleteDate(indexPath: NSIndexPath) {
        BaseDateWrapper(baseDate: dates[indexPath.row]).delete()
        fetch()
    }

    func move(#fromIndex: Int, toIndex: Int) {
        BaseDateWrapper.move(fromIndex: fromIndex, toIndex: toIndex)
        fetch()
    }
}