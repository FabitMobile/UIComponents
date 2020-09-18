import UIKit

public enum FlowLayoutHorizontalAlignment {
    case center
    case left
    case right
}

public enum FlowLayoutVerticalAlignment {
    case center
    case left
    case right
}

open class VerticalFlowLayout: UICollectionViewFlowLayout {
    var horizontalAlignment: FlowLayoutHorizontalAlignment = .center

    public convenience init(horizontalAlignment: FlowLayoutHorizontalAlignment) {
        self.init()
        self.horizontalAlignment = horizontalAlignment
    }

    // swiftlint:disable force_cast force_unwrapping
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        if let attributesSuper = super.layoutAttributesForElements(in: rect) {
            let attributes = NSArray(array: attributesSuper, copyItems: true) as! [UICollectionViewLayoutAttributes]
            if scrollDirection == .vertical {
                let collectionWidth = collectionView!.bounds.width
                attributes.forEach { attr in
                    var frame = attr.frame
                    if collectionWidth > frame.size.width {
                        switch horizontalAlignment {
                        case .left:
                            frame.origin.x = 0
                        case .right:
                            frame.origin.x = collectionWidth - frame.size.width
                        case .center:
                            frame.origin.x = (collectionWidth - frame.size.width) / 2.0
                        }
                        attr.frame = frame
                    }
                }
                layoutAttributes.append(contentsOf: attributes)
            } else {
                layoutAttributes.append(contentsOf: attributes)
            }
        }
        return layoutAttributes
    }

    // swiftlint:enable force_cast force_unwrapping
}
