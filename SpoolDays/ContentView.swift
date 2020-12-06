import SwiftUI

struct ContentView: View {
    let datesViewModel = DatesViewModel.initWithFetched()

    var body: some View {
        NavigationView {
            List {
                // TODO: implement BaseDate as Identifiable
                ForEach(self.datesViewModel.dates, id: \.sort) { date in
                    HStack {
                        Text(date.title)
                        Spacer()
                        Text("\(date.dateInterval()) \(I18n.translate("Days"))")
                            .foregroundColor(Color.gray)
                    }
                }
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
