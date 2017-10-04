//
//  FlaneurCollectionItemSectionController.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 14/09/2017.
//
//

import IGListKit

class FlaneurCollectionItemSectionController: ListSectionController {
    let borderWidth: CGFloat
    let nbColumns: Int
    var object: FlaneurCollectionItem
    let cellSizeRatio: CGFloat
    weak var collectionView: FlaneurCollectionView?

    init(object: FlaneurCollectionItem,
         collectionView: FlaneurCollectionView,
         borderWidth: CGFloat = 9.0,
         nbColumns: Int = 2,
         cellSizeRatio: CGFloat = 1.0) {
        self.object = object
        self.collectionView = collectionView
        self.borderWidth = borderWidth
        self.nbColumns = nbColumns
        self.cellSizeRatio = cellSizeRatio
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }

        let nbColumnsAsFloat = CGFloat(nbColumns)
        let squareSize = (context.containerSize.width - (2.0 + nbColumnsAsFloat - 1.0) * borderWidth) / nbColumnsAsFloat

        return CGSize(width: squareSize, height: squareSize * cellSizeRatio)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        var cell: UICollectionViewCell!

        switch object.cellStyle {
        case .nibName(let nibName):
            cell = collectionContext!.dequeueReusableCell(withNibName: nibName,
                                                              bundle: nil,
                                                              for: self,
                                                              at: index)
        case .cellClass(let cellClass):
            cell = collectionContext!.dequeueReusableCell(of: cellClass,
                                                          for: self,
                                                          at: index)
        }
        object.configureCell(cell: cell)
        return cell
    }

    override func didSelectItem(at index: Int) {
        if let collectionView = collectionView {
            collectionView.delegate?.flaneurCollectionView(collectionView, didSelectItem: object)
        }
    }

    override func didDeselectItem(at index: Int) {
        if let collectionView = collectionView {
            collectionView.delegate?.flaneurCollectionView(collectionView, didDeselectItem: object)
        }
    }

    override func didUpdate(to object: Any) {
        guard let newItem = object as? FlaneurCollectionItem else { fatalError("Wrong type in FlaneurCollectionItemSectionController") }
        self.object = newItem
    }
}
