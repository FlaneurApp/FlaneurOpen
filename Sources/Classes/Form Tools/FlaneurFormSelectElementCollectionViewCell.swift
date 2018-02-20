//
//  FlaneurFormSelectElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 09/10/2017.
//

import UIKit

public protocol FlaneurFormSelectElementCollectionViewCellDelegate: AnyObject {
    func selectCollectionViewSize() -> CGSize
    func nbOfItems() -> Int
    func cellClass() -> AnyClass?
    func cellReuseIdentifier() -> String
    func configure(cell: UICollectionViewCell, forIndex: Int)
    func allowMultipleSelection() -> Bool

    func selectElementDidSelectItemAt(index: Int)
    func selectElementDidDeselectItemAt(index: Int)
}

public extension FlaneurFormSelectElementCollectionViewCellDelegate where Self: UIViewController {
    func selectCollectionViewSize() -> CGSize {
        return CGSize(width: 44.0, height: 44.0)
    }
}

class FlaneurFormSelectElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    weak var selectDelegate: FlaneurFormSelectElementCollectionViewCellDelegate?

    let selectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 9.0 // Spacing between items
        // layout.minimumInteritemSpacing = 40.0 // Useless here. Because I have only 1 section?

        let result = UICollectionView(frame: .zero, collectionViewLayout: layout)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.backgroundColor = .white
        result.showsHorizontalScrollIndicator = false
        result.contentInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        return result
    }()

    var collectionViewHeightConstraint: NSLayoutConstraint?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        selectCollectionView.dataSource = self
        selectCollectionView.delegate = self

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
                           constant: 12.0).isActive = true
        collectionViewHeightConstraint = NSLayoutConstraint(item: selectCollectionView,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1.0,
                                                            constant: 44.0)
        collectionViewHeightConstraint?.isActive = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureWith(formElement: FlaneurFormElement) {
        guard let selectDelegate = selectDelegate else {
            fatalError("Having set `selectDelegate` is required at configuration time.")
        }
        guard let heightConstraint = collectionViewHeightConstraint else {
            fatalError("The height constraint should be set at init time.")
        }

        super.configureWith(formElement: formElement)

        // Update the height of the collection view
        heightConstraint.constant = selectDelegate.selectCollectionViewSize().height

        // Register the cell type
        selectCollectionView.register(selectDelegate.cellClass(),
                                      forCellWithReuseIdentifier: selectDelegate.cellReuseIdentifier())

        // Allow multiple selection
        selectCollectionView.allowsMultipleSelection = selectDelegate.allowMultipleSelection()

        formElement.didLoadHandler?(selectCollectionView)
    }

    override func becomeFirstResponder() -> Bool {
        delegate?.scrollToVisibleSection(cell: self)
        self.selectCollectionView.becomeFirstResponder()
        return true
    }
}

extension FlaneurFormSelectElementCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDelegate?.selectElementDidSelectItemAt(index: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectDelegate?.selectElementDidDeselectItemAt(index: indexPath.row)
    }
}

extension FlaneurFormSelectElementCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let selectDelegate = selectDelegate else {
            print("ERROR: selectDelegate is nil");
            return 0
        }
        return selectDelegate.nbOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let selectDelegate = selectDelegate else {
            fatalError("ERROR: selectDelegate is nil");
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectDelegate.cellReuseIdentifier(), for: indexPath)
        selectDelegate.configure(cell: cell, forIndex: indexPath.row)

        let isCollectionViewSelected = (collectionView.indexPathsForSelectedItems ?? []).contains(indexPath)
        if cell.isSelected && !isCollectionViewSelected {
            debugPrint("DEBUG: selecting indexPath for pre-selected item.")
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        }
        if !cell.isSelected && isCollectionViewSelected {
            debugPrint("WARN: deselecting indexPath for pre-selected item. This should never happen.")
            collectionView.deselectItem(at: indexPath, animated: false)
        }

        return cell
    }
}

extension FlaneurFormSelectElementCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let selectDelegate = selectDelegate else {
            print("ERROR: selectDelegate is nil");
            return .zero
        }

        return selectDelegate.selectCollectionViewSize()
    }
}

class FlaneurFormSelectBisElementCollectionViewCell: FlaneurFormSelectElementCollectionViewCell {

}
