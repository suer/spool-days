import Foundation
import UIKit

enum ThemeColor {
    static func baseColor() -> UIColor {
        return colorByRGB(red: 0, green: 195, blue: 121, alpha: 255)
    }

    static func baseTextColor() -> UIColor {
        return colorByRGB(red: 238, green: 238, blue: 238, alpha: 255)
    }

    static func resetColor() -> UIColor {
        return colorByRGB(red: 18, green: 191, blue: 41, alpha: 255)
    }

    static func deleteColor() -> UIColor {
        return colorByRGB(red: 211, green: 56, blue: 28, alpha: 255)
    }

    fileprivate static func colorByRGB(red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
        return UIColor(red: (CGFloat(red) / 255.0), green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
}
