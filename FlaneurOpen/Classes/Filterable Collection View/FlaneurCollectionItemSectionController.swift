//
//  FlaneurCollectionItemSectionController.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 14/09/2017.
//
//

import IGListKit

class FilterableSectionController: ListSectionController {
    let borderWidth: CGFloat
    let nbColumns: Int
    let object: FlaneurCollectionItem
    weak var collectionView: FlaneurCollectionView?

    init(object: FlaneurCollectionItem,
         collectionView: FlaneurCollectionView,
         borderWidth: CGFloat = 9.0,
         nbColumns: Int = 2) {
        self.object = object
        self.collectionView = collectionView
        self.borderWidth = borderWidth
        self.nbColumns = nbColumns
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }

        let nbColumnsAsFloat = CGFloat(nbColumns)
        let squareSize = (context.containerSize.width - (2.0 + nbColumnsAsFloat - 1.0) * borderWidth) / nbColumnsAsFloat

        return CGSize(width: squareSize, height: squareSize)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: object.nibName,
                                                          bundle: nil,
                                                          for: self,
                                                          at: index)

        object.configureCell(cell: cell)

        return cell
    }

    override func didSelectItem(at index: Int) {
        if let collectionView = collectionView {
            collectionView.delegate?.flaneurCollectionView(collectionView, didSelectItem: object)
        }
    }
}
