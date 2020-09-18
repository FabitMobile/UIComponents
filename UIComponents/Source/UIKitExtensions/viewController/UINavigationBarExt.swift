import UIKit

extension UINavigationBar {
    open func changeTransparency(_ transparent: Bool) {
        if transparent == true {
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
            isTranslucent = true
        } else {
            setBackgroundImage(nil, for: .default)
            shadowImage = nil
            isTranslucent = false
        }
    }
}
