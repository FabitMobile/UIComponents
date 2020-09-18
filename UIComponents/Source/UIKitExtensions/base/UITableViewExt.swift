import UIKit

extension UITableView {
    open func hideEmptyCells() {
        let view = UIView()
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        tableFooterView = view
    }
}
