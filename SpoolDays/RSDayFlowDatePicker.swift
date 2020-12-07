import SwiftUI
import RSDayFlow

struct RSDayFlowDatePicker: UIViewRepresentable {

    class Coordinator: NSObject, RSDFDatePickerViewDelegate {
        @Binding var date: Date
        @Binding var presentationMode: PresentationMode

        init(date: Binding<Date>, presentationMode: Binding<PresentationMode>) {
            _date = date
            _presentationMode = presentationMode
        }

        func datePickerView(_ view: RSDFDatePickerView!, didSelect date: Date!) {
            self.date = date
            self.presentationMode.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode

    @Binding var date: Date

    func makeUIView(context: UIViewRepresentableContext<RSDayFlowDatePicker>) -> RSDFDatePickerView {
        let datePicker = RSDFDatePickerView(frame: .zero)
        datePicker.delegate = context.coordinator
        datePicker.select($date.wrappedValue)
        datePicker.scroll(to: $date.wrappedValue, animated: true)
        return datePicker
    }

    func makeCoordinator() -> RSDayFlowDatePicker.Coordinator {
        return Coordinator(date: $date, presentationMode: presentationMode)
    }

    func updateUIView(_ uiView: RSDFDatePickerView, context: Context) {

    }

}
