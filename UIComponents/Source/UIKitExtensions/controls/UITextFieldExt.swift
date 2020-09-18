import UIKit

extension UITextField {
    open func setLeftPadding(_ value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }

    open func setRightPadding(_ value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: frame.size.height))
        rightView = paddingView
        rightViewMode = .always
    }
}
