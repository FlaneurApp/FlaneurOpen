//
//  String+FlaneurSpec.swift
//  FlaneurOpen_Tests
//
//  Created by Mickaël Floc'hlay on 13/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import FlaneurOpen

class StringFlaneurSpec: QuickSpec {
    override func spec() {
        describe("String have initials") {
            it("can perform with standard cases") {
                expect("Mick Floc".initials).to(equal("MF"))
                expect("mick floc".initials).to(equal("MF"))
                expect("mick floc'h".initials).to(equal("MF"))
                expect("Jean-Paul Bel Mondo".initials).to(equal("JB"))
            }

            it("can perform with edge cases") {
                expect("".initials).to(equal("-"))
                expect("mick".initials).to(equal("M"))
                expect("a b c".initials).to(equal("AB"))
                expect("🏀 ⚾️ 🎅".initials).to(equal("🏀⚾️"))
            }
        }
    }
}
