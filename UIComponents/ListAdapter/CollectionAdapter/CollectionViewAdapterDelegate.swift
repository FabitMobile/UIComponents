import UIKit

class CollectionViewAdapterDelegate: NSObject,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    // MARK: - Properties

    unowned var holder: CollectionViewAdapter
    var automaticHeaderFooterHeight: CGFloat = 0

    // MARK: - Init

    init(holder: CollectionViewAdapter) {
        self.holder = holder
    }

    // MARK: - getters

    private func section(for index: Int) -> CollectionSection? {
        guard index < holder.list.sections.count else { return nil }
        return holder.list.sections[index]
    }

    private func row(for section: CollectionSection, index: Int) -> CollectionItemConfigurable? {
        guard index < section.numberOfRows else { return nil }
        return section.rows[index]
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    // MARK: Size

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = holder.list.sections[indexPath.section].rows[indexPath.row]

        guard let size = row.cellVM.defaultSize ?? row.cellVM.estimatedSize else {
            fatalError("Need size for cell")
        }
        return size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt sectionIndex: Int) -> UIEdgeInsets {
        guard let section = section(for: sectionIndex) else { return .zero }
        return section.insets
    }

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource

    // MARK: Selecting

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return }

        if row.cellVM.deselectAutomatically {
            collectionView.deselectItem(at: indexPath, animated: true)
        }

        holder.callbacks.didSelectItem?(collectionView, indexPath, (section, row))
        row.cellVM.action?(row.cellVM.userInfo ?? row.cellVM)
    }

    // MARK: Number sections, items

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        holder.list.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        holder.list.sections[section].numberOfRows
    }

    // MARK: Cell

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let row = section(for: indexPath.section)?.rows[indexPath.row] else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.reuseId, for: indexPath)

        row.configure(collectionCell: cell)
        if let bindingCell = cell as? BindingCell & ConfigureCell {
            row.cellVM.bind(view: bindingCell)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let section = section(for: indexPath.section) else { return }
        let row = section.rows[indexPath.row]

        if let bindingCell = cell as? BindingCell & ConfigureCell {
            row.cellVM.bind(view: bindingCell)
        }

        holder.callbacks.willDisplayCollectionItem?(collectionView, cell, indexPath, (section, row))
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let bindingCell = cell as? BindingCell {
            bindingCell.unbind()
        }

        guard let section = section(for: indexPath.section),
            (section.rows.count - 1) > indexPath.row else { return }

        let row = section.rows[indexPath.row]

        holder.callbacks.didEndDisplayCollectionItem?(collectionView, cell, indexPath, (section, row))
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return false }
        return holder.callbacks.canMoveItem?(collectionView, indexPath, (section, row)) ?? false
    }

    func collectionView(_ collectionView: UICollectionView,
                        moveItemAt sourceIndexPath: IndexPath,
                        to destinationIndexPath: IndexPath) {
        guard let callback = holder.callbacks.commitMoveItem else { return }

        guard let sourceSection = section(for: sourceIndexPath.section),
            let sourceRow = row(for: sourceSection, index: sourceIndexPath.row)
        else { return }

        var destinationCollectionData: (CollectionSection, CollectionItemConfigurable)?

        if let destinationSection = section(for: destinationIndexPath.section),
            let destinationRow = row(for: destinationSection, index: destinationIndexPath.row) {
            destinationCollectionData = (destinationSection, destinationRow)
        }

        callback(collectionView,
                 sourceIndexPath,
                 destinationIndexPath,
                 (sourceSection, sourceRow),
                 destinationCollectionData)
    }

    // MARK: - ScroolViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        holder.scrollViewCallbacks.scrollViewDidScroll?(scrollView)
    }
}
