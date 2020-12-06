import SwiftUI

struct ContentView: View {
    let datesViewModel = DatesViewModel.initWithFetched()

    @State var showingActionSheet = false

    var body: some View {
        NavigationView {
            List {
                // TODO: implement BaseDate as Identifiable
                ForEach(self.datesViewModel.dates, id: \.sort) { date in
                    ZStack {
                        Button("") { self.showingActionSheet = true }
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
