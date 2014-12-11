import UIKit

class InvisibleDateTextField: UITextField {
    let datePicker: DatePicker

    init(datePicker: DatePicker) {
        self.datePicker = datePicker
        super.init(frame: CGRectMake(0, 0, 0, 0))
        inputView = datePicker
        inputAccessoryView = datePicker.datePickerToolBar()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
