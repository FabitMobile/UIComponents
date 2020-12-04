import UIKit

/// :nodoc:
public protocol UniqIdentifier {
    var identifier: String { get }
}

/// :nodoc:
public protocol SectionUniqIdentifier: UniqIdentifier {
    init(with id: String)
}
