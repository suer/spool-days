import Foundation

class DateTableViewCellAction {
    let name: String
    let action: (MainViewController, DateTableViewCell) -> Void

    init(name: String, action: @escaping (MainViewController, DateTableViewCell) -> Void) {
        self.name = name
        self.action = action
    }
}
