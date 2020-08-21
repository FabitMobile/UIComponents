import UIKit

public typealias GradientType = (x: CGPoint, y: CGPoint)

public enum GradientPoint {
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    case topRightBottomLeft
    case bottomLeftTopRight

    public func draw(_ x: CGPoint = .zero, _ y: CGPoint = .zero) -> GradientType {
        var xPoint: CGPoint = .zero
        var yPoint: CGPoint = .zero
        switch self {
        case .leftRight:
            xPoint = x != .zero ? x : CGPoint(x: 0, y: 0.5)
            yPoint = y != .zero ? y : CGPoint(x: 1, y: 0.5)

        case .rightLeft:
            xPoint = x != .zero ? x : CGPoint(x: 1, y: 0.5)
            yPoint = y != .zero ? y : CGPoint(x: 0, y: 0.5)

        case .topBottom:
            xPoint = x != .zero ? x : CGPoint(x: 0.5, y: 0)
            yPoint = y != .zero ? y : CGPoint(x: 0.5, y: 1)

        case .bottomTop:
            xPoint = x != .zero ? x : CGPoint(x: 0.5, y: 1)
            yPoint = y != .zero ? y : CGPoint(x: 0.5, y: 0)

        case .topLeftBottomRight:
            xPoint = x != .zero ? x : CGPoint(x: 0, y: 0)
            yPoint = y != .zero ? y : CGPoint(x: 1, y: 1)

        case .bottomRightTopLeft:
            xPoint = x != .zero ? x : CGPoint(x: 1, y: 1)
            yPoint = y != .zero ? y : CGPoint(x: 0, y: 0)

        case .topRightBottomLeft:
            xPoint = x != .zero ? x : CGPoint(x: 1, y: 0)
            yPoint = y != .zero ? y : CGPoint(x: 0, y: 1)

        case .bottomLeftTopRight:
            xPoint = x != .zero ? x : CGPoint(x: 0, y: 1)
            yPoint = y != .zero ? y : CGPoint(x: 1, y: 0)
        }

        return (x: xPoint, y: yPoint)
    }
}

open class GradientLayer: CAGradientLayer {
    public var gradient: GradientType? {
        didSet {
            startPoint = gradient?.x ?? CGPoint.zero
            endPoint = gradient?.y ?? CGPoint.zero
        }
    }
}

open class GradientView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class var layerClass: Swift.AnyClass {
        GradientLayer.self
    }
}

public protocol GradientViewProvider {
    associatedtype GradientViewType
}

public extension GradientViewProvider where Self: UIView {
    var gradientLayer: GradientViewType {
        // swiftlint:disable:next force_cast
        layer as! GradientViewType
    }
}

extension UIView: GradientViewProvider {
    public typealias GradientViewType = GradientLayer
}
