import UIKit

/// :nodoc:
public protocol EquatableRows {
    func rowsEqual(object: EquatableRows) -> Bool
}
