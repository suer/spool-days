import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).CGColor
        contentView.layer.borderWidth = 1
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
