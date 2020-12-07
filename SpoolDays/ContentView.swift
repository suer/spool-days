import SwiftUI

struct ContentView: View {
    var datesViewModel = DatesViewModel.initWithFetched()

    @State var showingActionSheet = false
    @State var showingResetAlert = false

    @State var selectedDate: BaseDate? = nil
    @State var resetDate: Date = Date()
    @State var lastModalPresentation: ModalPresentation? = nil

    enum ModalPresentation: View, Hashable, Identifiable {
        case editDateView(baseDate: BaseDate)
        case resetDateView(date: Binding<Date>)
        case historyView(baseDate: BaseDate)

        var body: some View {
            switch self {
            case .editDateView(let baseDate):
                return AnyView(EditDateView(baseDate: baseDate))
            case .resetDateView(let date):
                return AnyView(RSDayFlowDatePicker(date: date))
            case .historyView(let baseDate):
                let historyViewModel = HistoryViewModel(baseDate: baseDate)
                historyViewModel.fetch()
                return AnyView(HistoryView(historyViewModel: historyViewModel))
            }
        }

        var id: UUID {
            return UUID()
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case .editDateView(_): hasher.combine(1)
            case .resetDateView(_): hasher.combine(2)
            case .historyView(_): hasher.combine(3)
            }
        }

        static func == (lhs: ContentView.ModalPresentation, rhs: ContentView.ModalPresentation) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
    }

    @State var modalPresentation: ModalPresentation?

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
                        .sheet(item: self.$modalPresentation, onDismiss: {
                            switch self.lastModalPresentation {
                            case .editDateView(let baseDate):
                                baseDate.save()
                            case .resetDateView(let date):
                                self.selectedDate?.reset(date.wrappedValue)
                            case .historyView(_):
                                print("history view finished")
                            case .none:
                                print("none")
                            }
                        }) {
                            $0
                        }
                        .alert(isPresented: self.$showingResetAlert) {
                            Alert(title: Text(I18n.confirmation),
                                  message: Text(I18n.translate("Are you sure you want to reset date?")),
                                  primaryButton: .default(Text(I18n.yes)) {
                                    self.selectedDate.map { $0.reset(Date()) }
                                  },
                                  secondaryButton: .cancel(Text(I18n.no))
                            )
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
                                    if let baseDate = selectedDate {
                                        let modalPresentation: ModalPresentation = .editDateView(baseDate: baseDate)
                                        self.modalPresentation = modalPresentation
                                        self.lastModalPresentation = modalPresentation
                                    }
                                },
                                .default(Text(I18n.reset)) {
                                    self.showingResetAlert = true
                                },
                                .default(Text(I18n.reset_with_date)) {
                                    let modalPresentation: ModalPresentation = .resetDateView(date: self.$resetDate)
                                    self.modalPresentation = modalPresentation
                                    self.lastModalPresentation = modalPresentation
                                },
                                .default(Text(I18n.history)) {
                                    if let baseDate = selectedDate {
                                        let modalPresentation: ModalPresentation = .historyView(baseDate: baseDate)
                                        self.modalPresentation = modalPresentation
                                        self.lastModalPresentation = modalPresentation
                                    }
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
