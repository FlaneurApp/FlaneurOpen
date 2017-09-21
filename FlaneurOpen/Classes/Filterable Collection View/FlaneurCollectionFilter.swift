//
//  FlaneurCollectionFilter.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 14/09/2017.
//
//

import IGListKit

public class FlaneurCollectionFilter {
    let name: String
    let rightImage: UIImage?
    let filter: ((FlaneurCollectionItem) -> Bool)
    public let userInfo: Any?

    public init(name: String, rightImage: UIImage? = nil, userInfo: Any? = nil, filter: @escaping ((FlaneurCollectionItem) -> Bool)) {
        self.name = name
        self.rightImage = rightImage
        self.userInfo = userInfo
        self.filter = filter
    }
}

extension FlaneurCollectionFilter: ListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: name)
    }

    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let otherFilter = object as? FlaneurCollectionFilter {
            return otherFilter.name == self.name
        } else {
            return false
        }
    }
}

extension FlaneurCollectionFilter: FlaneurCollectionItem {
    public var nibName: String {
        return "TODO"
    }

    public func configureCell(cell: UICollectionViewCell) {
        if let cell = cell as? FlaneurFilterCollectionViewCell {
            cell.filterNameLabel.text = name
            cell.rightIconImage = self.rightImage
        }
    }
}
