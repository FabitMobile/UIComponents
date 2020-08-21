import Foundation

public protocol DeepEquatable {
    func equal(object: Any?) -> Bool
}

public protocol DeepHashable: DeepEquatable {
    var deepDiffHash: Int { get }
}

extension DeepHashable where Self: Hashable {
    public var deepDiffHash: Int {
        hashValue
    }
}

extension String: DeepHashable {
    public func equal(object: Any?) -> Bool {
        guard let object = object as? String else { return false }
        return self == object
    }
}

extension Character: DeepHashable {
    public func equal(object: Any?) -> Bool {
        guard let object = object as? Character else { return false }
        return self == object
    }
}
