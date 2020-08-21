import Foundation
import UIKit

open class CollectionViewAdapter {
    // MARK: - Properties

    private var _list: AdapterList = CollectionList()
    /// Описание данных таблицы
    public var list: CollectionList { _list }

    // swiftlint:disable:next weak_delegate
    private var collectionViewDelegate: CollectionViewAdapterDelegate!

    private let batchUpdater = BatchUpdater()

    // MARK: - Callbacks

    /// Обработка методов таблицы
    public let callbacks: CollectionAdapterCallbacks = CollectionAdapterCallbacks()

    /// Обработка методов scrollView
    public let scrollViewCallbacks: AdapterScrollViewCallbacks = AdapterScrollViewCallbacks()

    // MARK: - Dependencies

    public var collectionView: UICollectionView

    // MARK: - LifeCycle

    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView

        collectionViewDelegate = CollectionViewAdapterDelegate(holder: self)
        self.collectionView.delegate = collectionViewDelegate
        self.collectionView.dataSource = collectionViewDelegate
    }

    // MARK: - Private

    fileprivate func registerCells(sections: [CollectionSection]) {
        for section in sections {
            for row in section.rows {
                // >>> NIB
                if let cellNib = row.cellNib {
                    collectionView.register(cellNib, forCellWithReuseIdentifier: row.reuseId)
                } else {
                    collectionView.register(row.cellType, forCellWithReuseIdentifier: row.reuseId)
                }
                //=== was
                // collectionView.register(row.cellType, forCellWithReuseIdentifier: row.reuseId)
                // <<< NIB
            }
        }
    }

    // MARK: - Reload

    public func reload(with collectionList: CollectionList? = nil, completion: @escaping ((Bool) -> Void)) {
        registerCells(sections: collectionList?.sections ?? [])

        let oldList = _list

        if let list = collectionList {
            _list = list
        } else {
            _list = AdapterList()
        }

        if oldList.sections.isEmpty || _list.sections.isEmpty || collectionView.visibleCells.isEmpty {
            collectionView.reloadData()
            completion(true)
            return
        }

        batchUpdater.batchUpdate(collectionView: collectionView,
                                 oldSections: oldList.sections,
                                 newSections: list.sections,
                                 completion: completion)
    }
}
