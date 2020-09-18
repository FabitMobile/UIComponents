import UIKit

public extension NSParagraphStyle {
    static func center() -> NSParagraphStyle {
        withAlignment(NSTextAlignment.center)
    }

    static func left() -> NSParagraphStyle {
        withAlignment(NSTextAlignment.left)
    }

    static func right() -> NSParagraphStyle {
        withAlignment(NSTextAlignment.right)
    }

    static func justified() -> NSParagraphStyle {
        withAlignment(NSTextAlignment.justified)
    }

    static func withAlignment(_ alignment: NSTextAlignment) -> NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        return style
    }
}
