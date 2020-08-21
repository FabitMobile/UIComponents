import UIKit

// MARK: - hex

extension UIColor {
    public convenience init(hex string: String, alpha: CGFloat) {
        var hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        guard hex.count == 3 || hex.count == 6
        else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }

        self.init(
            // swiftlint:disable force_unwrapping
            red: CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue: CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0,
            alpha: alpha
        )
        // swiftlint:enable force_unwrapping
    }

    public convenience init(hex string: String) {
        self.init(hex: string, alpha: 1.0)
    }

    public func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

// MARK: - dimmed

extension UIColor {
    public func highlighted() -> UIColor {
        withAlphaComponent(0.2)
    }

    open func dimmedColor() -> UIColor {
        withBrightnessMultiplier(0.75)
    }

    open func withBrightnessMultiplier(_ multiplier: Double) -> UIColor {
        var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        let color = UIColor(hue: h, saturation: s, brightness: b * CGFloat(multiplier), alpha: a)
        return color
    }

    open func withBrightnessMax(_ bMax: Double) -> UIColor {
        var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        let max = CGFloat(bMax)
        if b > max { b = max }

        let color = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
        return color
    }
}
