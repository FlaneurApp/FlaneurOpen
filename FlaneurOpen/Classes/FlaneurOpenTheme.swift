//
//  FlaneurOpenTheme.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 12/10/2017.
//

import Foundation

public struct FlaneurOpenTheme {
    let segmentedControlFont: UIFont

    public init(segmentedControlFont: UIFont = UIFont.preferredFont(forTextStyle: .headline)) {
        self.segmentedControlFont = segmentedControlFont
    }
}

public final class FlaneurOpenThemeManager {
    public var theme: FlaneurOpenTheme = FlaneurOpenTheme()

    public static let shared = FlaneurOpenThemeManager()

    private init() {

    }
}
