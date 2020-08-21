import UIKit

open class TableRowConfigurable: ItemConfigurable, Equatable {
    /// Модель данных ячейки
    open var cellVM: TableCellVM {
        preconditionFailure("This method must be overridden")
    }

    public static func == (lhs: TableRowConfigurable, rhs: TableRowConfigurable) -> Bool {
        guard lhs.cellVM.isEqual(rhs.cellVM) else { return false }

        return true
    }
}
