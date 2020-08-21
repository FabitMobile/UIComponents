import UIKit

extension UITableView {
    func performBatchUpdates(sectionsChanges: SectionsChanges,
                             rowsChanges: RowsChanges,
                             changedData: [ChangedData],
                             completion: ((Bool) -> Void)?) {
        if #available(iOS 11.0, *) {
            performBatchUpdates({
                updateActions(sectionsChanges: sectionsChanges, rowsChanges: rowsChanges, changedData: changedData)
            }, completion: completion)

            reloadRows(at: rowsChanges.updates.map { $0.new }, with: .fade)
        } else {
            beginUpdates()
            updateActions(sectionsChanges: sectionsChanges, rowsChanges: rowsChanges, changedData: changedData)
            endUpdates()

            reloadRows(at: rowsChanges.updates.map { $0.new }, with: .fade)

            if let completion = completion {
                completion(true)
            }
        }
    }

    // MARK: - Private

    private func updateActions(sectionsChanges: SectionsChanges, rowsChanges: RowsChanges, changedData: [ChangedData]) {
        // sections
        deleteSections(sectionsChanges.deletes, with: .fade)
        insertSections(sectionsChanges.inserts, with: .fade)
        for move in sectionsChanges.moves {
            moveSection(move.from, toSection: move.to)
        }
        reloadSections(sectionsChanges.updates, with: .fade)

        // rows
        deleteRows(at: rowsChanges.deletes, with: .fade)
        insertRows(at: rowsChanges.inserts, with: .fade)
        for move in rowsChanges.moves {
            guard !sectionsChanges.deletes.contains(move.from.row),
                !sectionsChanges.inserts.contains(move.to.row) else {
                continue
            }
            moveRow(at: move.from, to: move.to)
        }

        for changeData in changedData {
            let indexPathsVisibleRows = indexPathsForVisibleRows ?? []
            guard let indexCell = indexPathsVisibleRows.firstIndex(of: changeData.oldIndexPath),
                let oldRow = changeData.oldRow as? TableRowConfigurable,
                let newRow = changeData.newRow as? TableRowConfigurable else {
                continue
            }

            let cell = visibleCells[indexCell]
            oldRow.cellVM.unbind()
            newRow.cellVM.unbind()
            newRow.configure(cell)

            cell.accessoryType = newRow.cellVM.accessoryType
            if let cell = cell as? BindingCell & ConfigureCell {
                newRow.cellVM.bind(view: cell)
            }
        }
    }
}
