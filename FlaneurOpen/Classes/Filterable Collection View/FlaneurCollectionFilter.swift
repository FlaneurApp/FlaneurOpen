//
//  FlaneurCollectionFilter.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 14/09/2017.
//
//

public struct FlaneurCollectionFilter {
    let name: String
    let filter: ((FlaneurCollectionItem) -> Bool)

    public init(name: String, filter: @escaping ((FlaneurCollectionItem) -> Bool)) {
        self.name = name
        self.filter = filter
    }
}
