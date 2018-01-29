//
//  FlaneurFormButtonCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 15/12/2017.
//

import Foundation

final class FlaneurFormButtonCollectionViewCell: FlaneurFormElementCollectionViewCell {
    public let textField = UITextField()
    public let otherLabel = UILabel()
    let otherTextField = UITextField()
    let actionButton = UIButton()

    public override init(frame: CGRect) {
         super.init(frame: frame)

        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.flaneurFormStyle()
        textField.isUserInteractionEnabled = false

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
                           constant: 6.0).isActive = true

        self.addSubview(otherLabel)
        otherLabel.translatesAutoresizingMaskIntoConstraints = false
        otherLabel.font = FlaneurOpenThemeManager.shared.theme.formLabelsFont
        otherLabel.topAnchor.constraint(equalTo: textField.bottomAnchor,
                                        constant: 30.0).isActive = true
        otherLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        otherLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16.0).isActive = true

        self.addSubview(otherTextField)
        otherTextField.translatesAutoresizingMaskIntoConstraints = false
        otherTextField.flaneurFormStyle()
        otherTextField.isUserInteractionEnabled = false
        otherTextField.topAnchor.constraint(equalTo: otherLabel.bottomAnchor,
                                            constant: 6.0).isActive = true
        otherTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        otherTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16.0).isActive = true

        self.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle("-", for: .normal)
        actionButton.topAnchor.constraint(equalTo: otherTextField.bottomAnchor,
                                            constant: 21.0).isActive = true
        actionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureWith(formElement: FlaneurFormElement) {
        super.configureWith(formElement: formElement)

        self.backgroundColor = UIColor(white: (248.0 / 255.0), alpha: 1.0)

        label.tag = 1
        textField.tag = 2
        otherLabel.tag = 3
        otherTextField.tag = 4
        actionButton.tag = 5

        formElement.didLoadHandler?(self)
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }
}
