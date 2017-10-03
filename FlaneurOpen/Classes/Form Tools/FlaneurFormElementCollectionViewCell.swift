//
//  FlaneurFormElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit

protocol FlaneurFormElementCollectionViewCellDelegate {
    func nextElementShouldBecomeFirstResponder(cell: FlaneurFormElementCollectionViewCell)
    func scrollToVisibleSection(cell: FlaneurFormElementCollectionViewCell)
    func presentViewController(viewController: UIViewController)
}

class FlaneurFormElementCollectionViewCell: UICollectionViewCell {
    var label: UILabel!
    var delegate: FlaneurFormElementCollectionViewCellDelegate? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    func didLoad() {
        let label = UILabel()
        self.label = label
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        _ = LayoutBorderManager(item: label,
                                toItem: self,
                                top: 16.0,
                                left: 16.0,
                                right: 16.0)

        createBottomBorder()
    }

    func configureWith(formElement: FlaneurFormElement) {
        label.text = formElement.label
    }
}
