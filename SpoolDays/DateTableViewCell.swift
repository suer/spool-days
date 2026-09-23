import UIKit

class DateTableViewCell: UITableViewCell {
    var dateViewModel: DateViewModel
    private let dayCountLabel = UILabel()
    private var countAnimationTask: Task<Void, Never>?
    private var displayedDayCount = 0 {
        didSet {
            dayCountLabel.attributedText = Self.dayCountText(days: displayedDayCount)
            if String(displayedDayCount).count != String(oldValue).count {
                dayCountLabel.sizeToFit()
            }
        }
    }

    init(reuseIdentifier: String?, dateViewModel: DateViewModel) {
        self.dateViewModel = dateViewModel
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resetDate(_ date: Date = Date(), completion: (() -> Void)? = nil) {
        dateViewModel.resetDate(date)
        animateDayCountChange(completion: completion)
    }

    fileprivate func configure() {
        guard let baseDate = dateViewModel.baseDate else { return }
        var content = UIListContentConfiguration.cell()
        content.text = baseDate.title
        contentConfiguration = content

        displayedDayCount = baseDate.dateInterval()
        dayCountLabel.sizeToFit()
        accessoryView = dayCountLabel
    }

    private func animateDayCountChange(completion: (() -> Void)?) {
        let fromDays = displayedDayCount
        guard let toDays = dateViewModel.baseDate?.dateInterval(), toDays != fromDays else {
            completion?()
            return
        }
        countAnimationTask?.cancel()

        let duration: TimeInterval = 0.6
        let startTime = Date()
        countAnimationTask = Task { @MainActor [weak self] in
            while true {
                guard let self, !Task.isCancelled else { return }
                let progress = min(-startTime.timeIntervalSinceNow / duration, 1.0)
                let eased = 1 - pow(1 - progress, 3)
                self.displayedDayCount = fromDays + Int((Double(toDays - fromDays) * eased).rounded())
                if progress >= 1.0 {
                    completion?()
                    return
                }
                try? await Task.sleep(for: .seconds(1.0 / 60))
            }
        }
    }

    private static let numberFont = roundedFont(ofSize: 24, weight: .semibold)
    private static let daySuffixText = NSAttributedString(
        string: " " + String(localized: .days),
        attributes: [
            .font: UIFont.preferredFont(forTextStyle: .footnote),
            .foregroundColor: ThemeColor.baseColor(),
        ])

    private static func dayCountText(days: Int) -> NSAttributedString {
        let text = NSMutableAttributedString(
            string: "\(days)",
            attributes: [
                .font: numberFont,
                .foregroundColor: ThemeColor.baseColor(),
            ])
        text.append(daySuffixText)
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
