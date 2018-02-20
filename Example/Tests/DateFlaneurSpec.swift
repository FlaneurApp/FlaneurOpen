import Quick
import Nimble
@testable import FlaneurOpen

class DateFlaneurSpec: QuickSpec {
    override func spec() {
        describe("Human readable time intervals") {
            context("when using French locale") {
                it("won't fail with the now date") {
                    expect(Date().humanReadableStringForTimeIntervalToNow()).toNot(beNil())
                }

                it("will work with reference dates") {
                    let refDate = Date(timeIntervalSince1970: 1518606000)

                    let locale = Locale.current.identifier
                    debugPrint(locale)

                    expect(Date(timeIntervalSince1970: 373555835).humanReadableStringForTimeIntervalToNow(refDate)).to(equal("About 36 years"))
                }
            }
        }
    }
}

