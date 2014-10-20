class DatesViewModel: RVMViewModel, UICollectionViewDataSource  {
    dynamic var dates: [BaseDate] = []

    func fetch() {
        dates = BaseDate.MR_findAllSortedBy("sort", ascending: true) as [BaseDate]
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as DateCollectionViewCell
        
        cell.dateViewModel.title = dates[indexPath.row].title
        cell.dateViewModel.date = dates[indexPath.row].date
        return cell
    }
}