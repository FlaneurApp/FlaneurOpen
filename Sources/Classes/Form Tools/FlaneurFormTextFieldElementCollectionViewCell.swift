//
//  FlaneurFormTextFieldElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit

final public class FlaneurFormTextFieldElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    let textField: UITextField = UITextField()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)

        textField.flaneurFormStyle()
        textField.returnKeyType = .next
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
                           constant: 8.0).isActive = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func configureWith(formElement: FlaneurFormElement) {
        super.configureWith(formElement: formElement)
        formElement.didLoadHandler?(textField)
    }

    override public func becomeFirstResponder() -> Bool {
        delegate?.scrollToVisibleSection(cell: self)
        return self.textField.becomeFirstResponder()
    }
}

extension FlaneurFormTextFieldElementCollectionViewCell: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.scrollToVisibleSection(cell: self)
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.nextElementShouldBecomeFirstResponder(cell: self)
        return true
    }
}
