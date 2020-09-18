import Foundation

struct Box: DeepHashable {
    var value: DeepHashable

    // MARK: - DeepHashable

    var deepDiffHash: Int {
        value.deepDiffHash
    }

    func equal(object: Any?) -> Bool {
        if let object = object as? Box {
            return value.equal(object: object.value)
        } else if let object = object as? DeepHashable {
            return value.equal(object: object)
        }

        return false
    }
}
