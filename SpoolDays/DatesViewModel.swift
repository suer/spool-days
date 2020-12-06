import Foundation

class DatesViewModel: NSObject {
    @objc dynamic var dates: [BaseDate] = []

    class func initWithFetched() -> DatesViewModel {
        let vm = DatesViewModel()
        vm.fetch()
        return vm
    }

    func fetch() {
        dates = BaseDate.mr_findAllSorted(by: "sort", ascending: true) as! [BaseDate]
        GroupData.setDates(dates)
    }

    func deleteDate(_ indexPath: IndexPath) {
        dates[(indexPath as NSIndexPath).row].delete()
        fetch()
    }

    func move(fromIndex: Int, toIndex: Int) {
        BaseDate.move(fromIndex: fromIndex, toIndex: toIndex)
        fetch()
    }
}
