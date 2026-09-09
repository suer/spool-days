import UIKit

enum ThemeColor {
    static func baseColor() -> UIColor {
        return UIColor(resource: .accent)
    }

    static func deleteColor() -> UIColor {
        return UIColor(resource: .delete)
    }
}
