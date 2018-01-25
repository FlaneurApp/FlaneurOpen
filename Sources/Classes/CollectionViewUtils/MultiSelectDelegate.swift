//
//  MultiSelectDelegate.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 25/01/2018.
//

import UIKit

class MultiSelectDelegate<Item: MultiSelectable>: NSObject {
    public var items: [Item] = []
    let cellDescriptor: (Item) -> CollectionViewCellDescriptor
    var reuseIdentifiers: Set<String> = []

    init(items: [Item], cellDescriptor: @escaping (Item) -> CollectionViewCellDescriptor) {
        self.items = items
        self.cellDescriptor = cellDescriptor
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let descriptor = cellDescriptor(item)

        if !reuseIdentifiers.contains(descriptor.reuseIdentifier) {
            collectionView.register(descriptor.cellClass,
                                    forCellWithReuseIdentifier: descriptor.reuseIdentifier)
            reuseIdentifiers.insert(descriptor.reuseIdentifier)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(cell)

        // Sync selection
        let selectedIndexes: [IndexPath] = collectionView.indexPathsForSelectedItems ?? []
        let collectionViewSelected = selectedIndexes.contains(indexPath)
        if item.isSelected {
            cell.isSelected = true
            if !collectionViewSelected {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            }
        } else {
            cell.isSelected = false
            if collectionViewSelected {
                collectionView.deselectItem(at: indexPath, animated: false)
            }
        }

        return cell
    }

    // MARK: - UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = true
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = false
    }
}

