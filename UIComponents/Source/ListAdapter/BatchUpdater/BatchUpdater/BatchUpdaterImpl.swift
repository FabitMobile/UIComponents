//
//  BatchUpdaterImpl.swift
//  UIComponents
//
//  Created by Дмитрий Рогов on 04.12.2020.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class BatchUpdaterImpl: UITableViewDiffableDataSource<TableSection, TableRowConfigurable>, BatchUpdater {
    func batchUpdate(tableView: UITableView,
                     oldSections: [TableSection],
                     newSections: [TableSection],
                     completion: ((Bool) -> Void)?) {
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, TableRowConfigurable>()
        
        snapshot.appendSections(newSections)
        
        for section in newSections {
            snapshot.appendItems(section.getRows())
        }
        
        self.apply(snapshot)
    }
}
