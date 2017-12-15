//
//  FlaneurFormTextAreaElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit

final class FlaneurFormTextAreaElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    var textArea: UITextView!

    /// Common init code.
    override func didLoad() {
        super.didLoad()

        let textArea = UITextView()
        self.textArea = textArea
        textArea.font = FlaneurOpenThemeManager.shared.theme.formTextAreaFont
        textArea.translatesAutoresizingMaskIntoConstraints = false
        textArea.text = ""
        textArea.returnKeyType = .next
        textArea.delegate = self

        self.addSubview(textArea)

        _ = LayoutBorderManager(item: textArea,
                                toItem: self,
                                left: 16.0,
                                bottom: 16.0,
                                right: 16.0)

        NSLayoutConstraint(item: textArea,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: label,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 4.0).isActive = true
    }

    override func configureWith(formElement: FlaneurFormElement) {
        super.configureWith(formElement: formElement)
        formElement.didLoadHandler?(textArea)
    }

    override func becomeFirstResponder() -> Bool {
        delegate?.scrollToVisibleSection(cell: self)
        return self.textArea.becomeFirstResponder()
    }
}

extension FlaneurFormTextAreaElementCollectionViewCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate?.scrollToVisibleSection(cell: self)
        return true
    }
}
