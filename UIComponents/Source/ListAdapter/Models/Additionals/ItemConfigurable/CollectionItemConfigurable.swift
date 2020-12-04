import UIKit

open class CollectionItemConfigurable: ItemConfigurable, Equatable, Hashable {
    /// Модель данных ячейки
    public var cellVM: CollectionCellVM {
        preconditionFailure("This method must be overridden")
    }

    public static func == (lhs: CollectionItemConfigurable, rhs: CollectionItemConfigurable) -> Bool {
        true
    }
    
    public func hash(into hasher: inout Hasher) {
        return 
    }
}
