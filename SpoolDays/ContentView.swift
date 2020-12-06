import SwiftUI

struct ContentView: View {
    var datesViewModel = DatesViewModel.initWithFetched()

    @State var showingActionSheet = false
    @State var showingEditView = false

    @State var selectedDate: BaseDate? = nil

    var body: some View {
        NavigationView {
            List {
                // TODO: implement BaseDate as Identifiable
                ForEach(self.datesViewModel.dates, id: \.sort) { date in
                    ZStack {
                        Button("") {
                            self.selectedDate = date
                            self.showingActionSheet = true
                        }
                        .sheet(isPresented: self.$showingEditView, onDismiss: {
                            self.selectedDate.map { $0.save() }
                        }) {
                            self.selectedDate.map { EditDateView(baseDate: $0) }
                        }
                        HStack {
                            Text(date.title)
                            Spacer()
                            Text("\(date.dateInterval()) \(I18n.translate("Days"))")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Action"),
                            buttons: [
                                .default(Text(I18n.edit)) {
                                    self.showingEditView = true
                                },
                                .default(Text(I18n.reset)) {

                                },
                                .default(Text(I18n.reset_with_date)) {

                                },
                                .default(Text(I18n.history)) {

                                },
                                .cancel(Text(I18n.cancel))
                            ]
                )
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("SpoolDays")
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
