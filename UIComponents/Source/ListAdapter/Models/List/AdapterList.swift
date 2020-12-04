import Foundation

public typealias TableList = AdapterList<TableSection>
public typealias CollectionList = AdapterList<CollectionSection>

/// Модель описывающая данные списка для TableViewAdapter и CollectionViewAdapter
open class AdapterList<SectionType: SectionUniqIdentifier & Equatable & EquatableRows & Hashable>: Equatable {
    // MARK: - Properties

    /// Список секций
    public var sections: [SectionType] = []

    // MARK: - Init

    public init() {}

    // MARK: - Subscript

    /// Найдет или создаст и вернет секцию с указаным идентификатором
    ///
    /// - Parameter id: Идентификатор секции
    public subscript(id: Int) -> SectionType {
        self["\(id)"]
    }

    /// Найдет или создаст и вернет секцию с указаным идентификатором
    ///
    /// - Parameter id: Идентификатор секции
    public subscript(id: String) -> SectionType {
        for section in sections where section.identifier == id {
            return section
        }

        return makeNewSection(with: id)
    }

    // MARK: - Private

    private func makeNewSection(with id: String) -> SectionType {
        let newSection = SectionType(with: id)
        sections.append(newSection)
        return newSection
    }

    public static func == (lhs: AdapterList<SectionType>, rhs: AdapterList<SectionType>) -> Bool {
        guard lhs.sections == rhs.sections else { return false }
        guard lhs.sections.elementsEqual(rhs.sections, by: { $0.rowsEqual(object: $1) }) else { return false }
        return true
    }
}

extension TableList {
    public func viewModel<T: SuperCellVM>(viewModel: T.Type, rowId: String? = nil, sectionId: String? = nil) -> T? {
        let section: TableSection?
        if let id = sectionId {
            section = self[id]
        } else {
            section = sections.first
        }

        guard let __section: TableSection = section else { return nil }

        let row: TableRowConfigurable?
        if let id = rowId {
            row = __section[id]
        } else {
            return __section.rows.compactMap { $0.cellVM as? T }.first
        }

        guard let vm = row?.cellVM as? T else { return nil }
        return vm
    }

    public func viewModels<T: SuperCellVM>(viewModel: T.Type, sectionId: String? = nil) -> [T] {
        let rows: [TableRowConfigurable]
        if let id = sectionId {
            rows = self[id].rows
        } else {
            rows = sections.map { $0.rows }.flatMap { $0 }
        }

        return rows.compactMap { $0.cellVM as? T }
    }
}

import UIKit

extension TableList {
    public func contentHeight() -> CGFloat {
        let viewModels = sections.flatMap { $0.rows.map { $0.cellVM } }
        let height = viewModels.compactMap { $0.defaultHeight }.reduce(0, +)
        return height
    }
}
