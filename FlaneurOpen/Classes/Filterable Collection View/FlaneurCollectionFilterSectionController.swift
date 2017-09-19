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
    var privateCellForOffRendering: FlaneurFilterCollectionViewCell

    init(object: FlaneurCollectionFilter,
         collectionView: FlaneurCollectionView) {
        self.object = object
        self.collectionView = collectionView
        self.privateCellForOffRendering = FlaneurFilterCollectionViewCell(frame: CGRect(x: 0.0, y: 0.0, width: 1000.0, height: 23.0))
    }

    override func sizeForItem(at index: Int) -> CGSize {
        object.configureCell(cell: privateCellForOffRendering)
        let size = CGSize(width: privateCellForOffRendering.recommendedWidthForCell(), height: 23.0)
        debugPrint("width for \(object.name):", size.width)
        return size
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
