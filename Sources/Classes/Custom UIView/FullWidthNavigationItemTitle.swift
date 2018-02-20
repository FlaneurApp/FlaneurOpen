//
//  FullWidthNavigationItemTitle.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 03/11/2017.
//

import UIKit

class FullWidthNavigationItemTitle: UIView {
    let leftMargin: CGFloat = 0.0
    let topMargin: CGFloat = 3.0 // Required for FlaneurApp :( - let's make it an attribute one day

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

        self.titleLabel?.frame = CGRect(x: leftMargin,
                                        y: topMargin,
                                        width: self.frame.width - leftMargin,
                                        height: referenceHeight - topMargin)
    }
}
