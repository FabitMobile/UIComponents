import UIKit

open class CollectionSection: AdapterSection<CollectionItemConfigurable>, EquatableRows {
    public var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    public static func == (lhs: CollectionSection, rhs: CollectionSection) -> Bool {
        guard lhs.id == rhs.id else { return false }
        guard lhs.insets == rhs.insets else {
            print("overrided equal insets does not equal error")
            return false
        }

        return true
    }

    override public func equal(object: Any?) -> Bool {
        guard let object = object as? CollectionSection else {
            print("overrided equal cast error")
            return false
        }
        return self == object
    }

    public func rowsEqual(object: EquatableRows) -> Bool {
        guard let rhs = object as? CollectionSection else { return false }
        guard rows == rhs.rows else { return false }

        return true
    }
}
