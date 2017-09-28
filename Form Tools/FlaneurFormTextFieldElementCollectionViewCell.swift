//
//  FlaneurFormTextFieldElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit

class FlaneurFormTextFieldElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    var textField: UITextField!

    /// Common init code.
    override func didLoad() {
        super.didLoad()

        let textField = UITextField()
        self.textField = textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)

        textField.returnKeyType = .next
        textField.borderStyle = .none
        textField.delegate = self

        _ = LayoutBorderManager(item: textField,
                                toItem: self,
                                left: 16.0,
                                right: 16.0)

        NSLayoutConstraint(item: textField,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: label,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 4.0).isActive = true
    }

    override func configureWith(formElement: FlaneurFormElement) {
        super.configureWith(formElement: formElement)
        formElement.didLoadHandler?(textField)
    }
}

extension FlaneurFormTextFieldElementCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.nextElementShouldBecomeFirstResponder(cell: self)
        return true
    }
}
