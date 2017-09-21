//
//  FlaneurMapAnnotation.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 21/09/2017.
//
//

import Foundation
import MapKit

public class FlaneurMapAnnotation: MKPointAnnotation {
    public let mapItem: FlaneurMapItem

    public init(mapItem: FlaneurMapItem) {
        self.mapItem = mapItem

        super.init()

        coordinate = mapItem.mapItemCoordinate2D
        title = mapItem.mapItemTitle
        subtitle = mapItem.mapItemAddress
    }
}
