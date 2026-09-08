import UIKit

class DateTableViewCell: UITableViewCell {
    var dateViewModel: DateViewModel

    init(reuseIdentifier: String?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resetDate() {
        dateViewModel.resetDate()
    }

    func resetDate(_ date: Date) {
        dateViewModel.resetDate(date)
    }

    fileprivate func configure() {
        guard let baseDate = dateViewModel.baseDate else { return }
        var content = UIListContentConfiguration.valueCell()
        content.text = baseDate.title
        content.secondaryAttributedText = Self.dayCountText(days: baseDate.dateInterval())
        contentConfiguration = content
    }

    private static func dayCountText(days: Int) -> NSAttributedString {
        let text = NSMutableAttributedString(
            string: "\(days)",
            attributes: [
                .font: roundedFont(ofSize: 24, weight: .semibold),
                .foregroundColor: ThemeColor.baseColor(),
            ])
        text.append(
            NSAttributedString(
                string: " " + String(localized: .days),
                attributes: [
                    .font: UIFont.preferredFont(forTextStyle: .footnote),
                    .foregroundColor: ThemeColor.baseColor(),
                ]))
        return text
    }

    private static func roundedFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let base = UIFont.systemFont(ofSize: size, weight: weight)
        guard let descriptor = base.fontDescriptor.withDesign(.rounded) else { return base }
        return UIFont(descriptor: descriptor, size: size)
    }
}

extension UITableViewCell {
    func setValueContent(text: String?, secondaryText: String?) {
        var content = UIListContentConfiguration.valueCell()
        content.text = text
        content.secondaryText = secondaryText
        contentConfiguration = content
    }
}
