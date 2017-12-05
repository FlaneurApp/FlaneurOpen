//
//  FlaneurCollectionItem.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 14/09/2017.
//
//

import IGListKit

public enum FlaneurCollectionItemCellStyle {
    case nibName(nibName: String)
    case cellClass(cellClass: AnyClass)
}

/// Protocol that items of a `FlaneurCollectionContainerView` must conform to.
public protocol FlaneurCollectionItem: ListDiffable {
    /// The style of instanciation for the cell.
    var cellStyle: FlaneurCollectionItemCellStyle { get }

    /// Configures the cell
    ///
    /// - Parameter cell: a cell from the NIB file given by `nibName`.
    func configureCell(cell: UICollectionViewCell)
}
