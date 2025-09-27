import UIKit
import HorizonCalendar

class DatePickerViewController: UIViewController {
    var calendarView: CalendarView!
    var initialDate: Date
    var onSelected: ((Date) -> Void)?

    init(initialDate: Date) {
        self.initialDate = initialDate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        edgesForExtendedLayout = UIRectEdge()
        automaticallyAdjustsScrollViewInsets = false
        loadDatePicker()
        loadCancelButton()
    }

    func loadDatePicker() {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .year, value: -10, to: Date())!
        let endDate = calendar.date(byAdding: .year, value: 10, to: Date())!
        calendarView = CalendarView(initialContent: makeContent(startDate: startDate, endDate: endDate))
        calendarView.daySelectionHandler = { [weak self] day in
            let selectedDate = calendar.date(from: day.components)!
            self?.dismiss(animated: true) {
                self?.onSelected?(selectedDate)
            }
        }
        view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        calendarView.scroll(toMonthContaining: initialDate, scrollPosition: .centered, animated: false)
    }
    private func makeContent(startDate: Date, endDate: Date) -> CalendarViewContent {
        let calendar = Calendar.current
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions(
                pinDaysOfWeekToTop: false,
                alwaysShowCompleteBoundaryMonths: false
            ))
        )
        .interMonthSpacing(48)
        .dayItemProvider { [weak self] day in
            var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive
            let selectedDay = calendar.dateComponents([.year, .month, .day], from: self?.initialDate ?? Date())
            let isSelected = day.components.year == selectedDay.year &&
                           day.components.month == selectedDay.month &&
                           day.components.day == selectedDay.day
            // Check if it's weekend (Saturday = 7, Sunday = 1)
            let date = calendar.date(from: day.components)!
            let weekday = calendar.component(.weekday, from: date)
            let isWeekend = weekday == 1 || weekday == 7  // Sunday = 1, Saturday = 7
            if isSelected {
                invariantViewProperties.backgroundShapeDrawingConfig = DrawingConfig(
                    fillColor: .systemBlue,
                    borderColor: .clear
                )
                invariantViewProperties.textColor = .white
            } else {
                invariantViewProperties.backgroundShapeDrawingConfig = DrawingConfig.transparent
                if isWeekend {
                    invariantViewProperties.textColor = .systemGray
                } else {
                    invariantViewProperties.textColor = .label
                }
            }
            return DayView.calendarItemModel(
                invariantViewProperties: invariantViewProperties,
                content: .init(dayText: "\(day.day)", accessibilityLabel: nil, accessibilityHint: nil)
            )
        }
    }

    func loadCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: I18n.translate("Cancel"), style: .plain, target: self, action: #selector(cancelButtonTapped))
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

}
