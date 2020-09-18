import UIKit

open class ShadowConfigurator {
    public init() {}

    open func configureAsNavBarShadow(_ element: ShadowableElement) {
        element.seShadowColor = .black
        element.seShadowOffset = CGSize(width: 0, height: CGFloat(1) / UIScreen.main.scale)
        element.seShadowOpacity = 0.25
        element.seShadowRadius = 0
    }
}
