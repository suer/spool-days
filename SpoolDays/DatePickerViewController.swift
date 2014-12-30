import UIKit

class DatePickerViewController: UIViewController, RSDFDatePickerViewDelegate {
    var datePicker: RSDFDatePickerView?
    var initialDate: NSDate
    var onSelected: ((NSDate) -> ())?

    init(initialDate: NSDate) {
        self.initialDate = initialDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        loadDatePicker()
        loadCancelButton()
    }

    func loadDatePicker() {
        datePicker = RSDFDatePickerView(frame: view.bounds)
        datePicker!.delegate = self
        view.addSubview(datePicker!)

        datePicker!.selectDate(initialDate)
        datePicker!.scrollToDate(initialDate, animated: true)
    }

    func datePickerView(view: RSDFDatePickerView!, didSelectDate date: NSDate!) {
        dismissViewControllerAnimated(true, completion: {
            if let selected = self.onSelected {
                selected(date)
            }
            return
        })
        dismissViewControllerAnimated(true) {
            if let selected = self.onSelected {
                selected(date)
            }
            return
        }
    }

    func loadCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .Plain, target: self, action: "cancelButtonTapped")
    }

    func cancelButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
