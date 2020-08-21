import UIKit

extension UINavigationController {
    open func changeNavigationBarTransparency(_ transparent: Bool) {
        if transparent == true {
            view.backgroundColor = navigationBar.barTintColor
        }
        navigationBar.changeTransparency(transparent)
    }

    open func changeNavigationBarShadowVisibility(_ hasShadow: Bool) {
        if hasShadow == true {
            navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            navigationBar.shadowImage = nil
        } else {
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
        }
    }

    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
