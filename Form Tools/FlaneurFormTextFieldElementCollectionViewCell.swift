//
//  FlaneurFormTextFieldElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit

class FlaneurFormTextFieldElementCollectionViewCell: UICollectionViewCell {
    var label: UILabel!
    var textField: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    /// Common init code.
    func didLoad() {
        self.backgroundColor = .white

        let label = UILabel()
        self.label = label
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        let textField = UITextField()
        self.textField = textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)

        textField.borderStyle = .none

        _ = LayoutBorderManager(item: label,
                                toItem: self,
                                top: 16.0,
                                left: 16.0,
                                right: 16.0)

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

        createBottomBorder()
    }

    func configureWith(formElement: FlaneurFormElement) {
        label.text = formElement.label
        formElement.didLoadHandler?(textField)
    }
}
