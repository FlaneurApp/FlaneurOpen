//
//  FlaneurFormSelectElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 09/10/2017.
//

import UIKit

public protocol FlaneurFormSelectElementCollectionViewCellDelegate {
    func selectCollectionViewSize() -> CGSize
    func nbOfItems() -> Int
    func cellClass() -> AnyClass?
    func cellReuseIdentifier() -> String
    func configure(cell: UICollectionViewCell, forIndex: Int)
    func allowMultipleSelection() -> Bool

    func didSelectItem(index: Int, cell: UICollectionViewCell)
    func didDeselectItem(index: Int, cell: UICollectionViewCell)
}

public extension FlaneurFormSelectElementCollectionViewCellDelegate where Self: UIViewController {
    func selectCollectionViewSize() -> CGSize {
        return CGSize(width: 44.0, height: 44.0)
    }
}

class FlaneurFormSelectElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    var selectDelegate: FlaneurFormSelectElementCollectionViewCellDelegate!
    var selectCollectionView: UICollectionView!
    var collectionViewHeightConstraint: NSLayoutConstraint!

    /// Common init code.
    override func didLoad() {
        super.didLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        self.selectCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        selectCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectCollectionView.dataSource = self
        selectCollectionView.delegate = self

        selectCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        layout.minimumLineSpacing = 9.0 // Spacing between items
        // layout.minimumInteritemSpacing = 40.0 // Useless here. Because I have only 1 section?

        self.addSubview(selectCollectionView)

        _ = LayoutBorderManager(item: selectCollectionView,
                                toItem: self,
                                left: 0.0,
                                right: 0.0)
        NSLayoutConstraint(item: selectCollectionView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: label,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 4.0).isActive = true
        collectionViewHeightConstraint = NSLayoutConstraint(item: selectCollectionView,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1.0,
                                                            constant: 44.0)
        collectionViewHeightConstraint.isActive = true
    }

    override func configureWith(formElement: FlaneurFormElement) {
        guard selectDelegate != nil else { fatalError("Setting selectDelegate is required")}

        super.configureWith(formElement: formElement)

        // Update the height of the collection view
        collectionViewHeightConstraint.constant = selectDelegate.selectCollectionViewSize().height

        // Register the cell type
        selectCollectionView.register(selectDelegate.cellClass(),
                                      forCellWithReuseIdentifier: selectDelegate.cellReuseIdentifier())

        // Allow multiple selection
        selectCollectionView.allowsMultipleSelection = selectDelegate.allowMultipleSelection()
    }
}

extension FlaneurFormSelectElementCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDelegate.didSelectItem(index: indexPath.row, cell: collectionView.cellForItem(at: indexPath)!)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectDelegate.didDeselectItem(index: indexPath.row, cell: collectionView.cellForItem(at: indexPath)!)
    }
}

extension FlaneurFormSelectElementCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectDelegate.nbOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectDelegate.cellReuseIdentifier(), for: indexPath)
        selectDelegate.configure(cell: cell, forIndex: indexPath.row)
        return cell
    }
}

extension FlaneurFormSelectElementCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return selectDelegate.selectCollectionViewSize()
    }
}
