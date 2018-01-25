//
//  PreSelectCollectionViewController.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 25/01/2018.
//

import UIKit

public struct CollectionViewCellDescriptor {
    let cellClass: UICollectionViewCell.Type
    let reuseIdentifier: String
    let configure: (UICollectionViewCell) -> ()

    public init<Cell: UICollectionViewCell>(reuseIdentifier: String, configure: @escaping (Cell) -> ()) {
        self.cellClass = Cell.self
        self.reuseIdentifier = reuseIdentifier
        self.configure = { cell in
            configure(cell as! Cell)
        }
    }
}

public protocol MultiSelectable: AnyObject {
    var isSelected: Bool { get set }
}

final public class MultiSelectCollectionViewController<Item: MultiSelectable>: UICollectionViewController {
    public var items: [Item] = []
    let cellDescriptor: (Item) -> CollectionViewCellDescriptor
    var reuseIdentifiers: Set<String> = []

    public init(collectionViewLayout: UICollectionViewLayout, items: [Item], cellDescriptor: @escaping (Item) -> CollectionViewCellDescriptor) {
        self.cellDescriptor = cellDescriptor
        super.init(collectionViewLayout: collectionViewLayout)
        self.items = items
        self.collectionView?.allowsMultipleSelection = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UICollectionViewDataSource

    override public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = true
    }

    override public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = false
    }
}
