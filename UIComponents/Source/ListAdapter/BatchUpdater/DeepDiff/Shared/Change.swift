import Foundation

public struct Insert<T> {
    public let item: T
    public let index: Int
}

public struct Delete<T> {
    public let item: T
    public let index: Int
}

public struct Replace<T> {
    public let oldItem: T
    public let newItem: T
    public let index: Int
}

public struct Move<T> {
    public let item: T
    public let fromIndex: Int
    public let toIndex: Int
}

/// The computed changes from diff
///
/// - insert: Insert an item at index
/// - delete: Delete an item from index
/// - replace: Replace an item at index with another item
/// - move: Move the same item from this index to another index
public enum Change<T> {
    case insert(Insert<T>)
    case delete(Delete<T>)
    case replace(Replace<T>)
    case move(Move<T>)

    public var insert: Insert<T>? {
        if case let .insert(insert) = self {
            return insert
        }

        return nil
    }

    public var delete: Delete<T>? {
        if case let .delete(delete) = self {
            return delete
        }

        return nil
    }

    public var replace: Replace<T>? {
        if case let .replace(replace) = self {
            return replace
        }

        return nil
    }

    public var move: Move<T>? {
        if case let .move(move) = self {
            return move
        }

        return nil
    }
}
