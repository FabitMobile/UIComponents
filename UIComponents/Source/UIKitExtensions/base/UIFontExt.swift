import UIKit

extension UIFont {
    open func boldFont() -> UIFont? {
        fontWithSymbolicTraits(.traitBold)
    }

    open func italicFont() -> UIFont? {
        fontWithSymbolicTraits(.traitItalic)
    }

    // swiftlint:disable force_cast
    open func fontWithSymbolicTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont? {
        let numberFontSize = fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName.size] as! NSNumber
        let fontSize = CGFloat(numberFontSize.floatValue)

        let newDescriptor = fontDescriptor.withSymbolicTraits(traits)
        let newFontName = newDescriptor?.fontAttributes[UIFontDescriptor.AttributeName.name] as! String
        let newFont = UIFont(name: newFontName, size: fontSize)
        return newFont
    }

    // swiftlint:enable force_cast
}
