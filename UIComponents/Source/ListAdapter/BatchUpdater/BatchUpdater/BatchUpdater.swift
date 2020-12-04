//
//  BatchUpdater.swift
//  UIComponents
//
//  Created by Дмитрий Рогов on 04.12.2020.
//

import Foundation
import UIKit

protocol BatchUpdater {
    func batchUpdate(tableView: UITableView,
                     oldSections: [TableSection],
                     newSections: [TableSection],
                     completion: ((Bool) -> Void)?)
    
    func batchUpdate(collectionView: UICollectionView,
                     oldSections: [CollectionSection],
                     newSections: [CollectionSection],
                     completion: ((Bool) -> Void)?)
}

extension BatchUpdater{
    func batchUpdate(tableView: UITableView,
                     oldSections: [TableSection],
                     newSections: [TableSection],
                     completion: ((Bool) -> Void)?) {
        fatalError("not implimented")
    }
    
    func batchUpdate(collectionView: UICollectionView,
                     oldSections: [CollectionSection],
                     newSections: [CollectionSection],
                     completion: ((Bool) -> Void)?) {
        fatalError("not implimented")
    }
}
