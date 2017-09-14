//
//  FlaneurCollectionItem.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 14/09/2017.
//
//

import IGListKit

/// Protocol that items of a `FlaneurCollectionContainerView` must conform to.
public protocol FlaneurCollectionItem: ListDiffable {
    /// The nib name to use for the cell. It will also be used as a reusable cell identifier.
    var nibName: String { get }

    /// Configures the cell
    ///
    /// - Parameter cell: a cell from the NIB file given by `nibName`.
    func configureCell(cell: UICollectionViewCell)
}
