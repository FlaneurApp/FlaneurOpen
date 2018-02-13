//
//  String+Flaneur.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 13/02/2018.
//

import Foundation

public extension String {
    public var initials: String {
        let candidate = self.components(separatedBy: " ")
            .filter { $0.count > 0 }
            .flatMap { String($0.first!) }
            .joined()
            .prefix(2)
            .uppercased()

        guard candidate.count > 0 else { return "-" }

        return candidate
    }
}
