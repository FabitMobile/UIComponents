import UIKit

open class CollectionItemConfigurable: ItemConfigurable, Equatable {
    /// Модель данных ячейки
    public var cellVM: CollectionCellVM {
        preconditionFailure("This method must be overridden")
    }

    public static func == (lhs: CollectionItemConfigurable, rhs: CollectionItemConfigurable) -> Bool {
        true
    }
}
