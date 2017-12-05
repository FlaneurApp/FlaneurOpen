//
//  FlaneurCollectionWithBorderListAdapter.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 14/09/2017.
//
//

import IGListKit

/// This adapter overrides ListAdapter to manage a border management.
/// It is designed to be used when IGListKit's `IGListCollectionViewLayout` is used.
class FlaneurCollectionWithBorderListAdapter: ListAdapter {
    let borderWidth: CGFloat

    init(updater: ListUpdatingDelegate, viewController: UIViewController?, workingRangeSize: Int, borderWidth: CGFloat = 9.0) {
        self.borderWidth = borderWidth
        super.init(updater: updater, viewController: viewController, workingRangeSize: workingRangeSize)
    }
}

extension FlaneurCollectionWithBorderListAdapter: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(borderWidth / 2.0, 0, borderWidth / 2.0, 0)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return borderWidth
    }
}
