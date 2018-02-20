//
//  FlaneurFormElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit

protocol FlaneurFormElementCollectionViewCellDelegate: AnyObject {
    func nextElementShouldBecomeFirstResponder(cell: FlaneurFormElementCollectionViewCell)
    func scrollToVisibleSection(cell: FlaneurFormElementCollectionViewCell)
    func presentViewController(viewController: UIViewController)
    func cacheValue(forLabel: String) -> String?
}

class FlaneurFormElementCollectionViewCell: UICollectionViewCell {
    let label = UILabel()
    var delegate: FlaneurFormElementCollectionViewCellDelegate? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = FlaneurOpenThemeManager.shared.theme.formLabelsFont
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        _ = LayoutBorderManager(item: label,
                                toItem: self,
                                top: 12.0,
                                left: 16.0,
                                right: 16.0)

        _ = createBottomBorder()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWith(formElement: FlaneurFormElement) {
        label.text = formElement.label
    }
}

extension UITextField {
    func flaneurFormStyle() {
        self.font = FlaneurOpenThemeManager.shared.theme.formTextFieldFont
        self.borderStyle = .none
    }
}
