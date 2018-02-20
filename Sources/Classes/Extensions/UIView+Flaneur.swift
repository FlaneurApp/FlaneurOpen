//
//  UIView+Flaneur.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit

public extension UIView {
    /// Create the bottom border
    func createBottomBorder(width: CGFloat = 1.0, color: UIColor = UIColor(white: 236.0 / 255.0, alpha: 1.0)) -> UIView {
        let bottomBorder = UIView()
        bottomBorder.transformIntoBottomBorder(parent: self,
                                               width: width,
                                               color: color)
        return bottomBorder
    }

    func transformIntoBottomBorder(parent: UIView, width: CGFloat = 1.0, color: UIColor = UIColor(white: 236.0 / 255.0, alpha: 1.0)) {
        backgroundColor = color
        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        _ = LayoutBorderManager(item: self, toItem: parent,
                                left: 0.0, bottom: 0.0, right: 0.0)
        NSLayoutConstraint(item: self,
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

    func respondsToTap(target: Any?, action: Selector?, numberOfTaps: Int = 1) {
        let tagGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        tagGestureRecognizer.numberOfTapsRequired = numberOfTaps
        self.addGestureRecognizer(tagGestureRecognizer)
        self.isUserInteractionEnabled = true
    }
}

