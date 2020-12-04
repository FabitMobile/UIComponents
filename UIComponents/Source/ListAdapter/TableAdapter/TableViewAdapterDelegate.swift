import UIKit

public class TableViewAdapterDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Types

    #if swift(>=4.2)
        public let TableViewAutomaticDimension = UITableView.automaticDimension

        public typealias TableViewCellEditingStyle = UITableViewCell.EditingStyle
    #else
        public let TableViewAutomaticDimension = UITableViewAutomaticDimension

        public typealias TableViewCellEditingStyle = UITableViewCellEditingStyle
    #endif

    // MARK: - Properties

    unowned var holder: TableViewAdapter
    var automaticHeaderFooterHeight: CGFloat = 0

    // MARK: - Init

    init(holder: TableViewAdapter) {
        self.holder = holder
        if holder.tableView.style == .grouped {
            automaticHeaderFooterHeight = TableViewAutomaticDimension
        }
    }

    // MARK: - getters

    private func section(for index: Int) -> TableSection? {
        guard index < holder.list.sections.count else { return nil }
        return holder.list.sections[index]
    }

    private func row(for section: TableSection, index: Int) -> TableRowConfigurable? {
        guard index < section.numberOfRows else { return nil }
        return section.rows[index]
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource

    // MARK: Size

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return 0 }

        return row.cellVM.defaultHeight ?? row.cellVM.estimatedHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return 0 }

        return row.cellVM.defaultHeight ?? TableViewAutomaticDimension
    }

    // MARK: Selecting

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return }

        if row.cellVM.deselectAutomatically {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        row.cellVM.action?(row.cellVM.userInfo ?? row.cellVM)

        guard let didSelectRowClosure = holder.callbacks.didSelectRow else { return }
        var newIndexPath: IndexPath?
        for (i, s) in holder.list.sections.enumerated() {
            for (j, r) in s.rows.enumerated() where r.identifier == row.identifier {
                newIndexPath = IndexPath(row: j, section: i)
                break
            }
        }
        if let newIndexPath = newIndexPath {
            didSelectRowClosure(tableView, newIndexPath, (section, row))
        }
    }

    // MARK: Number sections, items

    public func numberOfSections(in tableView: UITableView) -> Int {
        holder.list.sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !holder.list.sections.isEmpty else { return 0 }
        return holder.list.sections[section].numberOfRows
    }

    // MARK: Cell

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = section(for: indexPath.section)?.rows[indexPath.row] else { fatalError() }
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseId, for: indexPath)

        cell.selectionStyle = row.cellVM.isSelectable ? .default : .none
        cell.accessoryType = row.cellVM.accessoryType
        row.configure(cell)
        if let bindingCell = cell as? BindingCell & ConfigureCell {
            row.cellVM.bind(view: bindingCell)
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return }

        if let bindingCell = cell as? BindingCell & ConfigureCell {
            row.cellVM.bind(view: bindingCell)
        }

        holder.callbacks.willDisplayCell?(tableView, cell, indexPath, (section, row))
    }

    public func tableView(_ tableView: UITableView,
                          didEndDisplaying cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {
        if let bindingCell = cell as? BindingCell {
            bindingCell.unbind()
        }

        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return }

        holder.callbacks.didEndDisplayingCell?(tableView, cell, indexPath, (section, row))
    }

    // MARK: Edit

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return false }
        return holder.callbacks.canEditRow?(tableView, indexPath, (section, row)) ?? false
    }

    public func tableView(_ tableView: UITableView,
                          commit editingStyle: TableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return }
        holder.callbacks.commitEditRow?(tableView, indexPath, editingStyle, (section, row))
    }

    public func tableView(_ tableView: UITableView,
                          editingStyleForRowAt indexPath: IndexPath) -> TableViewCellEditingStyle {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return .none }
        return holder.callbacks.editingStyleRow?(tableView, indexPath, (section, row)) ?? .none
    }

    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView,
                          trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return nil }

        typealias CallbackType = TableAdapterCallbacks.TrailingSwipeActionsConfigurationForRow
        guard let callBack = holder.callbacks.trailingSwipeActionsConfigurationForRow as? CallbackType
        else { return nil }

        return callBack(tableView, indexPath, (section, row))
    }

    // MARK: Header / Footer

    // Header
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = self.section(for: section), section.headerView == nil else { return nil }
        return section.headerString
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = self.section(for: section) else { return nil }
        return section.headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = self.section(for: section) else {
            return automaticHeaderFooterHeight
        }
        return section.headerHeight ?? automaticHeaderFooterHeight
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let AdapterSection = self.section(for: section) else { return }
        holder.callbacks.willDisplayHeaderView?(tableView, view, AdapterSection, section)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard let AdapterSection = self.section(for: section) else { return }
        holder.callbacks.didEndDisplayHeaderView?(tableView, view, AdapterSection, section)
    }

    // Footer
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = self.section(for: section), section.footerView == nil else { return nil }
        return section.footerString
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let section = self.section(for: section) else { return nil }
        return section.footerView
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let section = self.section(for: section) else { return automaticHeaderFooterHeight }
        return section.footerHeight ?? automaticHeaderFooterHeight
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let AdapterSection = self.section(for: section) else { return }
        holder.callbacks.willDisplayFooterView?(tableView, view, AdapterSection, section)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        guard let AdapterSection = self.section(for: section) else { return }
        holder.callbacks.didEndDisplayFooterView?(tableView, view, AdapterSection, section)
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
        else { return false }
        return holder.callbacks.canMoveRow?(tableView, indexPath, (section, row)) ?? false
    }

    public func tableView(_ tableView: UITableView,
                          targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                          toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard let callback = holder.callbacks.moveDestinationRow else { return proposedDestinationIndexPath }

        guard let sourceSection = section(for: sourceIndexPath.section),
            let sourceRow = row(for: sourceSection, index: sourceIndexPath.row)
        else { return proposedDestinationIndexPath }

        var destinationTableData: (TableSection, TableRowConfigurable)?

        if let destinationSection = section(for: proposedDestinationIndexPath.section),
            let destinationRow = row(for: destinationSection, index: proposedDestinationIndexPath.row) {
            destinationTableData = (destinationSection, destinationRow)
        }

        return callback(tableView,
                        sourceIndexPath,
                        proposedDestinationIndexPath,
                        (sourceSection, sourceRow),
                        destinationTableData)
    }

    public func tableView(_ tableView: UITableView,
                          moveRowAt sourceIndexPath: IndexPath,
                          to destinationIndexPath: IndexPath) {
        guard let callback = holder.callbacks.commitMoveRow else { return }

        guard let sourceSection = section(for: sourceIndexPath.section),
            let sourceRow = row(for: sourceSection, index: sourceIndexPath.row)
        else { return }

        var destinationTableData: (TableSection, TableRowConfigurable)?

        if let destinationSection = section(for: destinationIndexPath.section),
            let destinationRow = row(for: destinationSection, index: destinationIndexPath.row) {
            destinationTableData = (destinationSection, destinationRow)
        }

        callback(tableView,
                 sourceIndexPath,
                 destinationIndexPath,
                 (sourceSection, sourceRow),
                 destinationTableData)
    }

    // MARK: - ScroolViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        holder.scrollViewCallbacks.scrollViewDidScroll?(scrollView)
    }
}
