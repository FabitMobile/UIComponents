import UIKit

open class TableRowConfigurable: ItemConfigurable, Equatable, Hashable {
    /// Модель данных ячейки
    open var cellVM: TableCellVM {
        preconditionFailure("This method must be overridden")
    }

    public static func == (lhs: TableRowConfigurable, rhs: TableRowConfigurable) -> Bool {
        guard lhs.cellVM.isEqual(rhs.cellVM) else { return false }

        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(cellVM)
    }
}
