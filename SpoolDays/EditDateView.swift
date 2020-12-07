import SwiftUI

struct EditDateView: View {
    @ObservedObject var baseDate: BaseDate

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $baseDate.title)
                DatePicker("Date", selection: $baseDate.date, displayedComponents: .date)
            }
            .navigationBarTitle("Edit Task")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .frame(width: 40, height: 40)
                    .imageScale(.large)
                    .foregroundColor(Color.gray)
                    .clipShape(Circle())
            })
        }
    }
}

struct EditDateView_Previews: PreviewProvider {
    static var previews: some View {
        EditDateView(baseDate: BaseDate())
    }
}
