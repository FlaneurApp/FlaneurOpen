//
//  FlaneurMapItem.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 21/09/2017.
//
//

import Foundation
import MapKit

/// The protocol to implement for an object to be able to be displayed on
/// a `FlaneurMapViewController` instance.
@objc public protocol FlaneurMapItem {
    /// The coordinate of the item
    var mapItemCoordinate2D: CLLocationCoordinate2D { get }

    /// The title to display by the annotation for the item.
    var mapItemTitle: String? { get }

    /// The address to display by the annotation for the item.
    var mapItemAddress: String? { get }

    /// The URL of the image to display by the annotation for the item.
    /// This property won't be used if `mapItemThumbnailImage` is set.
    var mapItemThumbnailURL: URL? { get }

    /// The image to display by the annotation for the item.
    /// This property has priority over `mapItemThumbnailURL`.
    var mapItemThumbnailImage: UIImage? { get }
}

