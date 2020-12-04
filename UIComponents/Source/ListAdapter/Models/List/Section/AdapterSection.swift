import UIKit

open class AdapterSection<ItemType: DeepHashable & UniqIdentifier & DeepEquatable & Hashable>:
    Hashable,
    SectionUniqIdentifier {
    
    typealias RowType = ItemType
    // MARK: - Properties

    /// Идентификатор
    public let identifier: String
    public private(set) var rows: [ItemType] = []

    // MARK: - Init

    public required init(with id: String) {
        self.identifier = id
    }

    // MARK: - Count

    /// Пустая ли секция
    public var isEmpty: Bool {
        rows.isEmpty
    }

    /// Количество элементов в секции
    public var numberOfRows: Int {
        rows.count
    }

    // MARK: - Update list rows

    /// Добавить строку в секцию
    ///
    /// - Parameter row: Добавляемая строка
    public func append(row: ItemType) {
        rows.append(row)
    }

    /// Добавить строки в секцию
    ///
    /// - Parameter rows: Добавляемые строки
    public func append(rows: [ItemType]) {
        self.rows.append(contentsOf: rows)
    }

    /// Вставка строки в секцию
    ///
    /// - Parameters:
    ///   - row: Вставляемая строка
    ///   - index: Индекс вставки
    public func insert(row: ItemType, at index: Int) {
        rows.insert(row, at: index)
    }

    /// Вставка строк в секцию
    ///
    /// - Parameters:
    ///   - rows: Вставляемые строки
    ///   - index: Начиная с какого индекса вставлять
    public func insert(rows: [ItemType], at index: Int) {
        self.rows.insert(contentsOf: rows, at: index)
    }

    /// Удалить строку по индексу
    ///
    /// - Parameter index: Индекс удаляемой строки
    /// - Returns: Удаленная строка
    @discardableResult
    public func remove(rowAt index: Int) -> ItemType {
        rows.remove(at: index)
    }

    /// Очистить список строк
    public func clear() {
        rows = []
    }

    // MARK: - Subscript

    /// Найдет и вернет строку с переданным id или nil иначе
    ///
    /// - Parameter id: Идентификатор строки
    public subscript(id: Int) -> ItemType? {
        self["\(id)"]
    }

    /// Найдет и вернет строку с переданным id или nil иначе
    ///
    /// - Parameter id: Идентификатор строки
    public subscript(id: String) -> ItemType? {
        for row in rows where row.identifier == id {
            return row
        }

        return nil
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    public static func == (lhs: AdapterSection, rhs: AdapterSection) -> Bool {
        guard lhs.identifier == rhs.identifier else { return false }
        guard lhs.equal(object: rhs) else { return false }
        return true
    }

    public func equal(object: Any?) -> Bool {
        guard let object = object as? AdapterSection else { return false }
        return self == object
    }

    // MARK: - BatchUpdateSection

    func getRows() -> [DeepHashable] {
        rows
    }
}
