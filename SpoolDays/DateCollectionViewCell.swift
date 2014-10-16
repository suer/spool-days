import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    var dateViewModel: DateViewModel

    override init(frame: CGRect) {
        dateViewModel = DateViewModel()
        super.init(frame: frame)
        contentView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).CGColor
        contentView.layer.borderWidth = 1

        loadCountLabel()
        loadTitleLabel()
    }

    func loadCountLabel() {
        let countLabel = UILabel(frame: CGRectMake(0, 0, contentView.bounds.width, contentView.bounds.height * 2 / 3))
        countLabel.font = UIFont.systemFontOfSize(countLabel.bounds.height / 2)
        countLabel.textAlignment = NSTextAlignment.Center
        countLabel.text = ""
        contentView.addSubview(countLabel)

        dateViewModel.rac_valuesForKeyPath("date", observer: dateViewModel).subscribeNext({
            obj in
            if obj == nil {
                return
            }
            let date = obj as NSDate
            countLabel.text = "\(Int(date.timeIntervalSinceNow / 60 / 60 / 24))"
            return
        })
    }

    func loadTitleLabel() {
        let titleLabel = UILabel(frame: CGRectMake(0, contentView.bounds.height * 2 / 3, contentView.bounds.width, contentView.bounds.height / 3))
        titleLabel.font = UIFont.systemFontOfSize(titleLabel.bounds.height / 2)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = ""
        contentView.addSubview(titleLabel)

        dateViewModel.rac_valuesForKeyPath("title", observer: dateViewModel).subscribeNext({
            obj in
            if obj == nil {
                return
            }
            let title = obj as String
            titleLabel.text = title
            return
        })
    }

    required init(coder aDecoder: NSCoder) {
        dateViewModel = DateViewModel()
        super.init(coder: aDecoder)
    }
}
