//
//  UILabel+Flaneur.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 07/09/2017.
//
//

import UIKit

public extension UILabel {
    /// Utility function to display a label with a custom letter spacing value.
    ///
    /// - Parameters:
    ///   - text: the text to be displayed by the label
    ///   - letterSpacing: the letter spacing to use. `0.0` is the default. Positive values will expand the text. Negative values will condense the text.
    public func flaneurText(_ text: String, letterSpacing: CGFloat = 0.0) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.kern,
                                      value: letterSpacing,
                                      range: NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
    }
}
