import UIKit

public extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor? {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return nil
        }
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor? {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return nil
        }
    }
}
