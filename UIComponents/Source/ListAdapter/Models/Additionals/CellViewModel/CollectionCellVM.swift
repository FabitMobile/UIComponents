import UIKit

/// :nodoc:
public protocol CollectionItemSizeComputable: AnyObject {
    var estimatedSize: CGSize? { get }
    var defaultSize: CGSize? { get }
}

/// :nodoc:
public extension CollectionItemSizeComputable {
    var estimatedSize: CGSize? { nil }
    var defaultSize: CGSize? { nil }
}

open class CollectionCellVM: SuperCellVM,
    CollectionItemSizeComputable {
    // MARK: - CollectionItemSizeComputable

    open var estimatedSize: CGSize? {
        nil
    }

    open var defaultSize: CGSize? {
        nil
    }
}
