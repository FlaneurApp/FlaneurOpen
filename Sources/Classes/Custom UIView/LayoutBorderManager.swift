//
//  LayoutBorderManager.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 26/09/2017.
//

import Foundation

public final class LayoutBorderManager {
    public private(set) weak var top: NSLayoutConstraint?
    public private(set) weak var left: NSLayoutConstraint?
    public private(set) weak var bottom: NSLayoutConstraint?
    public private(set) weak var right: NSLayoutConstraint?

    public init(item view1: UIView,
                toItem view2: UIView,
                top: CGFloat? = nil,
                left: CGFloat? = nil,
                bottom: CGFloat? = nil,
                right: CGFloat? = nil) {
        if let top = top {
            self.top = NSLayoutConstraint(item: view1,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: view2,
                                          attribute: .top,
                                          multiplier: 1.0,
                                          constant: top)
            self.top!.isActive = true
        } else {
            self.top = nil
        }

        if let left = left {
            self.left = NSLayoutConstraint(item: view1,
                                           attribute: .leading,
                                           relatedBy: .equal,
                                           toItem: view2,
                                           attribute: .leading,
                                           multiplier: 1.0,
                                           constant: left)
            self.left!.isActive = true
        } else {
            self.left = nil
        }

        if let bottom = bottom {
            self.bottom = NSLayoutConstraint(item: view1,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: view2,
                                             attribute: .bottom,
                                             multiplier: 1.0,
                                             constant: -bottom)
            self.bottom!.isActive = true
        } else {
            self.bottom = nil
        }

        if let right = right {
            self.right = NSLayoutConstraint(item: view1,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: view2,
                                            attribute: .trailing,
                                            multiplier: 1.0,
                                            constant: -right)
            self.right!.isActive = true
        } else {
            self.right = nil
        }
    }
}
