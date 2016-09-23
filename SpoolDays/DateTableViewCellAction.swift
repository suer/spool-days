import Foundation

class DateTableViewCellAction {
    let name: String
    let action: (MainViewController, DateTableViewCell) -> ()

    init(name: String, action: @escaping (MainViewController, DateTableViewCell) -> ()) {
        self.name = name
        self.action = action
    }
}
