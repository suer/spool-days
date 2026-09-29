import Foundation

struct DateTableViewCellAction {
    let name: String
    let action: (MainViewController, DateTableViewCell) -> Void
}
