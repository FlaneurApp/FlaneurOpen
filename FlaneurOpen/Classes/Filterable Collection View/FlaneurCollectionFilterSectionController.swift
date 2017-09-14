//
//  FlaneurCollectionFilterSectionController.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 14/09/2017.
//
//

import IGListKit

class FlaneurCollectionFilterSectionController: ListSectionController {
    let object: FlaneurCollectionFilter
    weak var collectionView: FlaneurCollectionView?

    init(object: FlaneurCollectionFilter,
         collectionView: FlaneurCollectionView) {
        self.object = object
        self.collectionView = collectionView
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 240, height: 23.0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: FlaneurFilterCollectionViewCell.self,
                                                          for: self,
                                                          at: index)

        object.configureCell(cell: cell)

        return cell
    }

    override func didSelectItem(at index: Int) {
        collectionView?.didSelectFilter(object)
    }
}
