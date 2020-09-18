import UIKit

extension UINavigationItem {
    public func setTitle(_ title: NSAttributedString, subtitle: NSAttributedString) {
        let lbTitle = UILabel()
        lbTitle.attributedText = title

        let lbSubtitle = UILabel()
        lbSubtitle.attributedText = subtitle

        let stackView = UIStackView(arrangedSubviews: [lbTitle, lbSubtitle])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center

        lbTitle.sizeToFit()
        lbSubtitle.sizeToFit()
        titleView = stackView
    }

    public func titleStyle() -> [Attributes] {
        let defaultFont = UIFont.boldSystemFont(ofSize: 17)
        let defaultForegroundColor = UIColor.white
        guard let titleTextAttributes = UINavigationBar.appearance().titleTextAttributes else {
            return [.font(defaultFont),
                    .foregroundColor(defaultForegroundColor)]
        }

        let font = titleTextAttributes[NSAttributedString.Key.font] as? UIFont
        let foregroundColor = titleTextAttributes[NSAttributedString.Key.foregroundColor] as? UIColor
        return [.font(font ?? defaultFont),
                .foregroundColor(foregroundColor ?? defaultForegroundColor)]
    }
}

extension UINavigationItem {
    public func removeNextBackButtonTitle() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backBarButtonItem = backItem
    }
}
