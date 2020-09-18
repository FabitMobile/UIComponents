import UIKit

public protocol KeyboardManagerDelegate: AnyObject {
    func keyboardManager(_ keyboardManager: KeyboardManager, keyboardWillChangeFrame frame: CGRect)
    func keyboardManager(_ keyboardManager: KeyboardManager, keyboardWillChangeBottomOffset bottomOffset: CGFloat)
}

public class KeyboardManager: NSObject {
    public weak var delegate: KeyboardManagerDelegate?

    var scrollView: UIScrollView
    public var additionalContentInset: UIEdgeInsets

    public init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        additionalContentInset = UIEdgeInsets.zero

        super.init()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    func keyboardWillChangeFrame(notification: NSNotification) {
        let key = UIResponder.keyboardFrameEndUserInfoKey
        if let keyboardFrame = (notification.userInfo?[key] as? NSValue)?.cgRectValue {
            delegate?.keyboardManager(self, keyboardWillChangeFrame: keyboardFrame)

            let keyboardBottomInset = UIScreen.main.bounds.size.height - keyboardFrame.origin.y
            delegate?.keyboardManager(self, keyboardWillChangeBottomOffset: keyboardBottomInset)

            var inset = scrollView.contentInset
            inset.bottom = keyboardBottomInset
            if additionalContentInset != UIEdgeInsets.zero {
                inset.top += additionalContentInset.top
                inset.bottom += additionalContentInset.bottom
                inset.left += additionalContentInset.left
                inset.right += additionalContentInset.right
            }
            scrollView.contentInset = inset
        }
    }
}

public extension KeyboardManagerDelegate {
    func keyboardManager(_: KeyboardManager, keyboardWillChangeFrame _: CGRect) {}
    func keyboardManager(_: KeyboardManager, keyboardWillChangeBottomOffset _: CGFloat) {}
}
