import UIKit

public extension UITableView {
    func emptyFooter() {
        tableFooterView = UIView()
    }

    func emptyHeader() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude)
        tableHeaderView = view
    }
}
