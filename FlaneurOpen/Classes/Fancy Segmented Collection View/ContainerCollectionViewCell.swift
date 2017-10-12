//
//  ContainerCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 12/10/2017.
//

import UIKit

class ContainerCollectionViewCell: UICollectionViewCell {
    var containedView: UIView?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didLoad()
    }

    func didLoad() {

    }

    func configureWithView(containedView: UIView) {
        self.containedView?.removeFromSuperview()
        self.containedView = containedView
        self.addSubview(self.containedView!)
        self.containedView!.translatesAutoresizingMaskIntoConstraints = false
        _ = LayoutBorderManager(item: self.containedView!,
                                toItem: self,
                                top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
