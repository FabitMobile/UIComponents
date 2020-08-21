import Foundation

public protocol DiffAware {
    func diff<T: DeepHashable>(old: [T], new: [T]) -> [Change<T>]
}

extension DiffAware {
    func preprocess<T: DeepHashable>(old: [T], new: [T]) -> [Change<T>]? {
        switch (old.isEmpty, new.isEmpty) {
        case (true, true):
            // empty
            return []
        case (true, false):
            // all .insert
            return new.enumerated().map { index, item in
                .insert(Insert(item: item, index: index))
            }
        case (false, true):
            // all .delete
            return old.enumerated().map { index, item in
                .delete(Delete(item: item, index: index))
            }
        default:
            return nil
        }
    }
}
