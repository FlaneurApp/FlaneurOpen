//
//  FlaneurFormSelectElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 09/10/2017.
//

import UIKit

public protocol FlaneurFormSelectElementCollectionViewCellDelegate {
    func selectCollectionViewHeight() -> CGFloat
}

public extension FlaneurFormSelectElementCollectionViewCellDelegate where Self: UIViewController {
    func selectCollectionViewHeight() -> CGFloat {
        return 44.0
    }
}

class FlaneurFormSelectElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    var selectDelegate: FlaneurFormSelectElementCollectionViewCellDelegate!
    var selectCollectionView: UICollectionView!

    /// Common init code.
    override func didLoad() {
        super.didLoad()

        self.selectCollectionView = UICollectionView()
        selectCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(selectCollectionView)

        _ = LayoutBorderManager(item: selectCollectionView,
                                toItem: self,
                                left: 0.0,
                                bottom: 0.0)
        NSLayoutConstraint(item: selectCollectionView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: label,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 4.0).isActive = true
        NSLayoutConstraint(item: selectCollectionView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: selectDelegate.selectCollectionViewHeight()).isActive = true
    }
}
