//
//  MapKit+Additions.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 30/01/2018.
//

import Foundation
import CoreLocation
import MapKit

public extension CLLocationCoordinate2D {
    /// Location of the center of Boston, MA (USA).
    static let boston = CLLocationCoordinate2D(latitude: 42.360794774307664,
                                               longitude: -71.108187343824667)

    /// Location of the center of France.
    static let franceCenter = CLLocationCoordinate2D(latitude: 46.713155158363762,
                                                     longitude: 1.7633167468633208)

    /// Location of the center of Brest (France).
    static let brest = CLLocationCoordinate2D(latitude: 48.406413450379041,
                                              longitude: -4.4987723478649029)
}

public extension MKCoordinateSpan {
    /// Coordinate span for a neighborhood scale (up to a few blocks).
    static let neighborhood = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

    /// Coordinate span for a small village size (ie no more than 30 minute walk).
    static let village = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)

    /// Coordinate span for a small city.
    static let smallCity = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)

    /// Coordinate span for a large metropolitan area.
    static let metropolitan = MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)

    /// Coordinate span for a small country.
    static let smallCountry = MKCoordinateSpan(latitudeDelta: 15.0, longitudeDelta: 15.0)
}

public extension MKCoordinateRegion {
    /// The coordinate region for France.
    static let france = MKCoordinateRegion(center: .franceCenter,
                                           span: .smallCountry)

    /// The coordinate region for the Greater Boston Area.
    static let greaterBostonArea = MKCoordinateRegion(center: .boston,
                                                      span: .metropolitan)

    /// The coordinate region for Brest métropole.
    static let brestMetropole = MKCoordinateRegion(center: .brest,
                                                   span: .smallCity)
}

public extension MKMapView {
    /// Submits the request to create a snapshot of the map view
    /// and delivers the results to the specified block.
    ///
    /// - Parameters:
    ///   - defaultSize: An optional size to use in case the view has an empty frame.
    ///   - completionHandler: The block to call with the resulting snapshot. This block is executed on the app’s main thread and must not be nil.
    func snapshot(defaultSize: CGSize? = nil,
                  completionHandler: @escaping (MKMapSnapshot?, Error?) -> Void) {
        guard let snapshotSize = (self.frame.isEmpty ? defaultSize : self.frame.size) else {
            debugPrint("Skipping snapshot of zero-sized map")
            return
        }

        let options = MKMapSnapshotOptions()
        options.region = self.region
        options.size = snapshotSize
        options.scale = UIScreen.main.scale

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start(completionHandler: completionHandler)
    }
}
