import UIKit

open class CollectionAdapterCallbacks {
    // MARK: - Types

    public typealias CollectionData = (section: CollectionSection, row: CollectionItemConfigurable)

    // MARK: - Props

    // MARK: - Select

    public typealias DidSelectItem = (UICollectionView, IndexPath, CollectionData) -> Void
    private(set) var didSelectItem: DidSelectItem?

    public func setDidSelectItem(_ block: DidSelectItem?) {
        didSelectItem = block
    }

    // MARK: - Cell

    public typealias DidEndDisplayCollectionItem = (UICollectionView,
                                                    UICollectionViewCell,
                                                    IndexPath,
                                                    CollectionData) -> Void
    public typealias WillDisplayCollectionItem = (UICollectionView,
                                                  UICollectionViewCell,
                                                  IndexPath,
                                                  CollectionData) -> Void

    private(set) var willDisplayCollectionItem: WillDisplayCollectionItem?
    private(set) var didEndDisplayCollectionItem: DidEndDisplayCollectionItem?

    public func setWillDisplayCollectionItem(_ block: WillDisplayCollectionItem?) {
        willDisplayCollectionItem = block
    }

    public func setDidEndDisplayCollectionItem(_ block: DidEndDisplayCollectionItem?) {
        didEndDisplayCollectionItem = block
    }

    // MARK: - Move

    public typealias CanMoveItem = (UICollectionView, IndexPath, CollectionData) -> Bool
    public typealias CommitMoveItem = (UICollectionView, IndexPath, IndexPath, CollectionData, CollectionData?) -> Void
    private(set) var canMoveItem: CanMoveItem?
    private(set) var commitMoveItem: CommitMoveItem?

    public func setCanMoveItem(_ block: CanMoveItem?) {
        canMoveItem = block
    }

    public func setCommitMoveItem(_ block: CommitMoveItem?) {
        commitMoveItem = block
    }
}
