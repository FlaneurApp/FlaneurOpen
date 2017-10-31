//
//  FlaneurFormDeleteElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 10/10/2017.
//

import UIKit

public protocol FlaneurFormDeleteElementCollectionViewCellDelegate: AnyObject {
    func flaneurFormCellDidRequestDeletion()
}

class FlaneurFormDeleteElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    weak var tapDelegate: FlaneurFormDeleteElementCollectionViewCellDelegate?

    override func didLoad() {
        super.didLoad()

        _ = LayoutBorderManager(item: label,
                                toItem: self,
                                bottom: 16.0)
        label.textAlignment = .center
        label.font = FlaneurOpenThemeManager.shared.theme.formDeleteFont
        label.textColor = UIColor(red: (226.0 / 255.0), green: (0.0 / 255.0), blue: (26.0 / 255.0), alpha: 1.0)

        label.respondsToTap(target: self, action: #selector(labelTapped))
    }

    @IBAction func labelTapped(_ sender: Any? = nil) {
        tapDelegate?.flaneurFormCellDidRequestDeletion()
    }
}
