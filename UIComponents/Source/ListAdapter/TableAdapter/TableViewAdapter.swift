import Foundation
import UIKit

open class TableViewAdapter {
    // MARK: - Properties

    private var _list: TableList = TableList()
    /// Описание данных таблицы
    public var list: TableList { _list }

    // swiftlint:disable:next weak_delegate
    public var delegate: TableViewAdapterDelegate?

    private var batchUpdater: BatchUpdater!

    // MARK: - Callbacks

    /// Обработка методов таблицы
    public let callbacks: TableAdapterCallbacks = TableAdapterCallbacks()

    /// Обработка методов scrollView
    public let scrollViewCallbacks: AdapterScrollViewCallbacks = AdapterScrollViewCallbacks()

    // MARK: - Dependencies

    public var tableView: UITableView

    // MARK: - LifeCycle

    public init(tableView: UITableView) {
        self.tableView = tableView

        delegate = TableViewAdapterDelegate(holder: self)
        self.tableView.delegate = delegate
        self.tableView.dataSource = delegate
        
        if #available(iOS 13.0, *) {
            self.batchUpdater = BatchUpdaterImpl()
        } else {
            self.batchUpdater = LegacyBatchUpdater()
        }
    }

    // MARK: - Private

    fileprivate func registerCells(sections: [TableSection]) {
        for section in sections {
            for row in section.rows {
                // >>> NIB
                if let cellNib = row.cellNib {
                    tableView.register(cellNib, forCellReuseIdentifier: row.reuseId)
                } else {
                    tableView.register(row.cellType, forCellReuseIdentifier: row.reuseId)
                }
                //=== was
                // tableView.register(row.cellType, forCellReuseIdentifier: row.reuseId)
                // <<< NIB
            }
        }
    }

    // MARK: - Reload

    public func reload(with tableList: TableList? = nil, _ completion: @escaping ((Bool) -> Void)) {
        registerCells(sections: tableList?.sections ?? [])

        let oldList = _list

        if let list = tableList {
            _list = list
        } else {
            _list = AdapterList()
        }

        if oldList.sections.isEmpty || _list.sections.isEmpty || tableView.visibleCells.isEmpty {
            tableView.reloadData()
            tableView.layoutIfNeeded()
            completion(true)
            
            return
        }

        batchUpdater.batchUpdate(tableView: tableView,
                                 oldSections: oldList.sections,
                                 newSections: list.sections,
                                 completion: completion)
    }
}
