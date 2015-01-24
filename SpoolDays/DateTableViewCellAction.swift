import Foundation

class DateTableViewCellAction {
    let name: String
    let action: (MainViewController, DateTableViewCell) -> ()

    init(name: String, action: (MainViewController, DateTableViewCell) -> ()) {
        self.name = name
        self.action = action
    }
}