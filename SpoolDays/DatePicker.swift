import UIKit

class DatePicker: UIDatePicker {
    let datePickerHeight = CGFloat(300.0)
    let valueChanged: (NSDate) -> ()
    init(valueChanged: (NSDate) -> ()) {
        self.valueChanged = valueChanged
        super.init(frame: CGRectMake(0, 0, 0, 0))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        if let v = superview {
            frame = CGRectMake(0, v.bounds.height - datePickerHeight, v.bounds.width, datePickerHeight)
        }
        datePickerMode = UIDatePickerMode.Date
        addTarget(self, action: Selector("datePickerValueChanged"), forControlEvents: UIControlEvents.ValueChanged)

    }

    func datePickerValueChanged() {
        valueChanged(date)
    }

    func datePickerToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.translucent = true
        toolbar.tintColor = nil
        toolbar.sizeToFit()
        let todayButton = UIBarButtonItem(title: NSLocalizedString("Today", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: "todayButtonTapped")
        toolbar.setItems([todayButton], animated: false)
        return toolbar
    }

    func todayButtonTapped() {
        date = NSDate()
        datePickerValueChanged()
    }
}
