//
//  FullWidthNavigationItemTitle.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 03/11/2017.
//

import UIKit

class FullWidthNavigationItemTitle: UIView {
    weak var containingView: UIView?

    var titleLabel: UILabel? {
        didSet {
            guard titleLabel != nil else { return }
            self.addSubview(titleLabel!)
        }
    }

    override func layoutSubviews() {
        guard let referenceHeight = self.containingView?.frame.height else { return }

        if self.frame.height != referenceHeight {
            self.frame = CGRect(x: self.frame.origin.x,
                                y: self.frame.origin.y,
                                width: self.frame.width,
                                height: referenceHeight)
        }

        self.titleLabel?.frame = CGRect(x: 16.0,
                                        y: 0.0,
                                        width: self.frame.width - 16.0,
                                        height: referenceHeight)
    }
}
