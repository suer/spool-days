import UIKit
import RSDayFlow

class DatePickerViewController: UIViewController, RSDFDatePickerViewDelegate {
    var datePicker: RSDFDatePickerView?
    var initialDate: Date
    var onSelected: ((Date) -> ())?

    init(initialDate: Date) {
        self.initialDate = initialDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        automaticallyAdjustsScrollViewInsets = false
        loadDatePicker()
        loadCancelButton()
    }

    func loadDatePicker() {
        datePicker = RSDFDatePickerView(frame: view.bounds)
        datePicker!.delegate = self
        view.addSubview(datePicker!)

        datePicker!.select(initialDate)
        datePicker!.scroll(to: initialDate, animated: true)
    }

    func datePickerView(_ view: RSDFDatePickerView!, didSelect date: Date!) {
        dismiss(animated: true) {
            if let selected = self.onSelected {
                selected(date)
            }
        }
    }

    func loadCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: I18n.translate("Cancel"), style: .plain, target: self, action: #selector(cancelButtonTapped))
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

}
