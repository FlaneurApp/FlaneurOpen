//
//  FlaneurOpenTheme.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 12/10/2017.
//

import Foundation

public struct FlaneurOpenTheme {
    let segmentedSelectedControlFont: UIFont
    let segmentedDeselectedControlFont: UIFont
    let formLabelsFont: UIFont
    let formTextFieldFont: UIFont
    let formTextAreaFont: UIFont
    let formDeleteFont: UIFont
    let navigationBarTitleFont: UIFont

    public init(segmentedSelectedControlFont: UIFont = UIFont.preferredFont(forTextStyle: .headline),
                segmentedDeselectedControlFont: UIFont = UIFont.preferredFont(forTextStyle: .headline),
                formLabelsFont: UIFont = UIFont.preferredFont(forTextStyle: .headline),
                formTextFieldFont: UIFont = UIFont.preferredFont(forTextStyle: .body),
                formTextAreaFont: UIFont = UIFont.preferredFont(forTextStyle: .body),
                formDeleteFont: UIFont = UIFont.preferredFont(forTextStyle: .callout),
                navigationBarTitleFont: UIFont = UIFont.preferredFont(forTextStyle: .headline)) {
        self.segmentedSelectedControlFont = segmentedSelectedControlFont
        self.segmentedDeselectedControlFont = segmentedDeselectedControlFont
        self.formLabelsFont = formLabelsFont
        self.formTextFieldFont = formTextFieldFont
        self.formTextAreaFont = formTextAreaFont
        self.formDeleteFont = formDeleteFont
        self.navigationBarTitleFont = navigationBarTitleFont
    }
}

public final class FlaneurOpenThemeManager {
    public var theme: FlaneurOpenTheme = FlaneurOpenTheme()

    public static let shared = FlaneurOpenThemeManager()

    private init() {

    }
}
