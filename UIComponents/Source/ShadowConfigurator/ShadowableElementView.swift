import UIKit

extension UIView: ShadowableElement {
    public var seShadowColor: UIColor? {
        get {
            guard let layerShadowColor = layer.shadowColor else { return nil }
            return UIColor(cgColor: layerShadowColor)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    public var seShadowOffset: CGSize {
        get {
            layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    public var seShadowOpacity: CGFloat {
        get {
            CGFloat(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }

    public var seShadowRadius: CGFloat {
        get {
            layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}
