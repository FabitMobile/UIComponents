import UIKit

// MARK: - components

public extension UIColor {
    struct RGBA {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat

        public func asInt64Mask() -> Int64 {
            let r = Int64(red * 255) & 0xFF
            let g = Int64(green * 255) & 0xFF
            let b = Int64(blue * 255) & 0xFF
            let a = Int64(alpha * 255) & 0xFF

            let result = (r << 24) + (g << 16) + b << 8 + a
            return result & 0x00000000ffffffff
        }
    }

    var rgbaComponents: RGBA {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor.RGBA: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(red.hashValue)
        hasher.combine(green.hashValue)
        hasher.combine(blue.hashValue)
        hasher.combine(alpha.hashValue)
    }
}
