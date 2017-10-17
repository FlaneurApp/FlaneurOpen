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

    public init(segmentedSelectedControlFont: UIFont = UIFont.preferredFont(forTextStyle: .headline),
                segmentedDeselectedControlFont: UIFont = UIFont.preferredFont(forTextStyle: .headline)) {
        self.segmentedSelectedControlFont = segmentedSelectedControlFont
        self.segmentedDeselectedControlFont = segmentedDeselectedControlFont
    }
}

public final class FlaneurOpenThemeManager {
    public var theme: FlaneurOpenTheme = FlaneurOpenTheme()

    public static let shared = FlaneurOpenThemeManager()

    private init() {

    }
}
