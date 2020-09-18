import UIKit

extension UIViewController {
    open func adjustsScrollViewInsets(_ adjust: Bool) {
        if adjust == false {
            automaticallyAdjustsScrollViewInsets = false
            extendedLayoutIncludesOpaqueBars = true
        } else {
            automaticallyAdjustsScrollViewInsets = true
            extendedLayoutIncludesOpaqueBars = false
        }
    }
}
