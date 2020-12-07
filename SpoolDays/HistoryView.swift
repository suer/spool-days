import SwiftUI

struct HistoryView: View {

    @State var historyViewModel: HistoryViewModel

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                ForEach(historyViewModel.logs, id: \.date) { log in
                    HStack {
                        Text(log.dateString())
                        Spacer()
                        Text(log.eventString())
                            .foregroundColor(Color.gray)
                    }
                }
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

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(historyViewModel: HistoryViewModel(baseDate: BaseDate()))
    }
}
