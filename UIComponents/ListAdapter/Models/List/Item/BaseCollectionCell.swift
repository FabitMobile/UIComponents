import Foundation
import UIKit

enum CollectionCellSelectionStyle {
    case none, normal
}

open class BaseCollectionCell: UICollectionViewCell {
    var selectionStyle: CollectionCellSelectionStyle = .normal

    fileprivate var normalBackgroundColor: UIColor?
    var highlightedColor: UIColor?

    override public var isHighlighted: Bool {
        willSet {
            if selectionStyle != .none {
                let viewBackground = viewForBackground()

                if newValue == true {
                    normalBackgroundColor = viewBackground.backgroundColor

                    if let highlightedColor = highlightedColor {
                        viewBackground.backgroundColor = highlightedColor
                    } else {
                        viewBackground.backgroundColor = viewBackground.backgroundColor?.dimmedColor()
                    }
                } else if let normalBackgroundColor = normalBackgroundColor {
                    viewBackground.backgroundColor = normalBackgroundColor
                }
            }
        }
    }

    func viewForBackground() -> UIView {
        contentView
    }
}
