//
//  UIView+Flaneur.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit

public extension UIView {
    /// Create the bottom border
    func createBottomBorder(width: CGFloat = 1.0) {
        let bottomBorder = UIView(frame: .zero)
        bottomBorder.backgroundColor = UIColor(white: 236.0 / 255.0, alpha: 1.0)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        _ = LayoutBorderManager(item: bottomBorder, toItem: self,
                                left: 0.0, bottom: 0.0, right: 0.0)

        NSLayoutConstraint(item: bottomBorder,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: width).isActive = true
    }

    func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    func removeAllGestureRecognizers() {
        if let gestureRecognizers = self.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                self.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
}

