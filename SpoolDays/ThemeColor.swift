import UIKit

enum ThemeColor {
    static func baseColor() -> UIColor {
        return UIColor(resource: .accent)
    }

    static func baseTextColor() -> UIColor {
        return UIColor(resource: .baseText)
    }

    static func resetColor() -> UIColor {
        return UIColor(resource: .reset)
    }

    static func deleteColor() -> UIColor {
        return UIColor(resource: .delete)
    }
}
