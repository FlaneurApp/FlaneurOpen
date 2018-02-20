//
//  Date+Flaneur.swift
//  ActionKit
//
//  Created by Mickaël Floc'hlay on 14/02/2018.
//

import Foundation

public extension Date {
    func humanReadableStringForTimeIntervalToNow(_ nowDate: Date = Date()) -> String? {
        let timeInterval = nowDate.timeIntervalSince(self)
        let dateC = DateComponents(second: Int(timeInterval))
        let dateF = DateComponentsFormatter()
        dateF.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        dateF.includesApproximationPhrase = true
        dateF.collapsesLargestUnit = true
        dateF.maximumUnitCount = 1
        dateF.zeroFormattingBehavior = .dropAll
        dateF.includesTimeRemainingPhrase = false
        dateF.unitsStyle = .full
        return dateF.string(from: dateC)
    }
}
