//
//  FlaneurFormImagePickerElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit

class FlaneurFormImagePickerElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    var launcherButton: UIButton!

    /// Common init code.
    override func didLoad() {
        super.didLoad()

        let launcherButton = UIButton()
        launcherButton.backgroundColor = UIColor(white: (39.0 / 255.0), alpha: 1.0)
        self.launcherButton = launcherButton
        launcherButton.translatesAutoresizingMaskIntoConstraints = false
        launcherButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        launcherButton.tintColor = .white
        self.addSubview(launcherButton)

        _ = LayoutBorderManager(item: launcherButton,
                                toItem: self,
                                left: 16.0,
                                bottom: 16.0)

        NSLayoutConstraint(item: launcherButton,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: label,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 4.0).isActive = true
        NSLayoutConstraint(item: launcherButton,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 80.0).isActive = true
        NSLayoutConstraint(item: launcherButton,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 80.0).isActive = true
    }

    override func configureWith(formElement: FlaneurFormElement) {
        super.configureWith(formElement: formElement)

        if case FlaneurFormElementType.imagePicker(let buttonImage) = formElement.type {
            launcherButton.setImage(buttonImage.withRenderingMode(.alwaysTemplate),
                                    for: .normal)
        }

        formElement.didLoadHandler?(launcherButton)
    }

    override func becomeFirstResponder() -> Bool {
        delegate?.scrollToVisibleSection(cell: self)
        launcherButton.isSelected = true
        return true
    }

    func buttonPressed(_ sender: Any? = nil) {
        self.becomeFirstResponder()
        debugPrint("buttonPressed")
    }
}
