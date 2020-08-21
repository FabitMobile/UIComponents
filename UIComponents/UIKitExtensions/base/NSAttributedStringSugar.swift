import UIKit

public enum Attributes {
    case minLineHeight(CGFloat)
    case font(UIFont)
    case foregroundColor(UIColor)
    case backgroundColor(UIColor)
    case kern(CGFloat)
    case alignment(NSTextAlignment)
    case lineSpacing(CGFloat)
    case lineHeightMultiple(CGFloat)
    case strikethroughStyle(NSUnderlineStyle)
    case underlineStyle(NSUnderlineStyle)
    case lineBreakMode(NSLineBreakMode)
}

extension Array where Element == Attributes {
    public func font() -> UIFont? {
        for element in self {
            switch element {
            case let .font(font):
                return font
            default:
                break
            }
        }
        return nil
    }

    public func makeDict() -> [NSAttributedString.Key: Any] {
        var result: [NSAttributedString.Key: Any] = [:]

        let paragraph = { (dict: inout [NSAttributedString.Key: Any]) -> NSMutableParagraphStyle in
            if let style = dict[.paragraphStyle] as? NSMutableParagraphStyle {
                return style
            } else {
                let style = NSMutableParagraphStyle()
                dict[.paragraphStyle] = style
                return style // its a ref value, so it's fine
            }
        }
        for attrib in self {
            switch attrib {
            case let .font(font):
                result[.font] = font
            case let .foregroundColor(color):
                result[.foregroundColor] = color
            case let .backgroundColor(color):
                result[.backgroundColor] = color
            case let .kern(value):
                result[.kern] = value
            case let .minLineHeight(height):
                paragraph(&result).minimumLineHeight = height
            case let .alignment(alignment):
                paragraph(&result).alignment = alignment
            case let .lineSpacing(value):
                paragraph(&result).lineSpacing = value
            case let .lineHeightMultiple(value):
                paragraph(&result).lineHeightMultiple = value
            case let .strikethroughStyle(style):
                result[.strikethroughStyle] = style.rawValue
            case let .underlineStyle(style):
                result[.underlineStyle] = style.rawValue
            case let .lineBreakMode(value):
                paragraph(&result).lineBreakMode = value
            }
        }
        return result
    }
}

extension Collection where Element == Attributes {
    public func font() -> UIFont {
        for attrib in self {
            switch attrib {
            case let .font(font):
                return font
            default:
                break
            }
        }
        return .systemFont(ofSize: 14, weight: .medium)
    }
}

extension String {
    public func attributed(_ attributes: [Attributes]) -> NSAttributedString {
        NSAttributedString(string: self, attributes: attributes.makeDict())
    }
}

extension NSAttributedString {
    public func appending(_ otherString: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        result.append(otherString)
        return NSAttributedString(attributedString: result)
    }

    public func appending(_ otherString: String) -> NSAttributedString {
        appending(NSAttributedString(string: otherString))
    }

    public func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect,
                                       options: .usesLineFragmentOrigin,
                                       context: nil)
        return ceil(boundingBox.height)
    }
}
