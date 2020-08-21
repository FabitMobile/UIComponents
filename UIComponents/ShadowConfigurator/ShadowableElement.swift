import UIKit

public protocol ShadowableElement: AnyObject {
    var seShadowColor: UIColor? { get set }
    var seShadowOffset: CGSize { get set }
    var seShadowOpacity: CGFloat { get set }
    var seShadowRadius: CGFloat { get set }
}
