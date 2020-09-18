import UIKit

extension UICollectionView {
    func performBatchUpdates(sectionsChanges: SectionsChanges,
                             rowsChanges: RowsChanges,
                             changedData: [ChangedData],
                             completion: ((Bool) -> Void)?) {
        performBatchUpdates({
            updateActions(sectionsChanges: sectionsChanges,
                          rowsChanges: rowsChanges,
                          changedData: changedData)
        }, completion: completion)

        reloadItems(at: rowsChanges.updates.map { $0.new })
    }

    // MARK: - Private

    private func updateActions(sectionsChanges: SectionsChanges,
                               rowsChanges: RowsChanges,
                               changedData: [ChangedData]) {
        // sections
        deleteSections(sectionsChanges.deletes)
        insertSections(sectionsChanges.inserts)
        for move in sectionsChanges.moves {
            moveSection(move.from, toSection: move.to)
        }
        reloadSections(sectionsChanges.updates)

        // items
        deleteItems(at: rowsChanges.deletes)
        insertItems(at: rowsChanges.inserts)
        for move in rowsChanges.moves {
            guard !sectionsChanges.deletes.contains(move.from.row),
                !sectionsChanges.inserts.contains(move.to.row) else {
                continue
            }
            moveItem(at: move.from, to: move.to)
        }

        for changeData in changedData {
            let indexPathsVisibleItems = indexPathsForVisibleItems

            guard let indexCell = indexPathsVisibleItems.firstIndex(of: changeData.oldIndexPath),
                let oldRow = changeData.oldRow as? CollectionItemConfigurable,
                let newRow = changeData.newRow as? CollectionItemConfigurable else {
                continue
            }

            let cell = visibleCells[indexCell]
            oldRow.cellVM.unbind()
            newRow.cellVM.unbind()
            newRow.configure(collectionCell: cell)
            if let cell = cell as? BindingCell & ConfigureCell {
                newRow.cellVM.bind(view: cell)
            }
        }
    }
}
