import UIKit

/// Протокол описывающий поля для высоты ячейки
/// :nodoc:
public protocol RowHeightComputable: AnyObject {
    var estimatedHeight: CGFloat? { get }
    var defaultHeight: CGFloat? { get }
}

open class TableCellVM: SuperCellVM,
    RowHeightComputable {
    // MARK: - Types

    #if swift(>=4.2)
        public typealias TableViewCellAccessoryType = UITableViewCell.AccessoryType
    #else
        public typealias TableViewCellAccessoryType = UITableViewCellAccessoryType
    #endif

    // MARK: - Properties

    /// Выделяемая ячейка или нет
    open var isSelectable: Bool = true
    open var accessoryType: TableViewCellAccessoryType = .none

    // MARK: - RowHeightComputable

    open var estimatedHeight: CGFloat? {
        nil
    }

    open var defaultHeight: CGFloat? {
        nil
    }

    func isEqual(_ rhs: TableCellVM) -> Bool {
        guard isSelectable == rhs.isSelectable else { return false }
        guard accessoryType == rhs.accessoryType else { return false }
        return true
    }
}
