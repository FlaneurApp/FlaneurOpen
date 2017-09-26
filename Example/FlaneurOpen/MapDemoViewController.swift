//
//  MapDemoViewController.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 04/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen
import MapKit

class DemoMapItem: FlaneurMapItem {
    var mapItemThumbnailImage: UIImage? = nil

    let coordinate2D: CLLocationCoordinate2D
    let title: String
    let address: String
    let thumbnailURL: URL

    init(mapItemThumbnailImage: UIImage?,
         coordinate2D: CLLocationCoordinate2D,
         title: String,
         address: String,
         thumbnailURL: URL) {
        self.mapItemThumbnailImage = mapItemThumbnailImage
        self.coordinate2D = coordinate2D
        self.title = title
        self.address = address
        self.thumbnailURL = thumbnailURL
    }

    var mapItemCoordinate2D: CLLocationCoordinate2D {
        get {
            return coordinate2D
        }
    }

    var mapItemTitle: String? {
        get {
            return title
        }
    }

    var mapItemAddress: String? {
        get {
            return address
        }
    }

    var mapItemThumbnailURL: URL? {
        get {
            return thumbnailURL
        }
    }
}

class MapDemoViewController: UIViewController, FlaneurMapViewDelegate {
    @IBOutlet weak var mapView: FlaneurMapView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIButton.appearance(whenContainedInInstancesOf: [MKAnnotationView.self]).tintColor = .green
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        configureMapView()
    }

    func configureMapView() {
        mapView.delegate = self
        mapView.annotationImage = UIImage(named: "sample-908-target")
        mapView.rightCalloutImage = UIImage(named: "sample-321-like")?.withRenderingMode(.alwaysTemplate)
        mapView.leftCalloutPlaceholderImage = UIImage(named: "sample-908-target")
        mapView.mapItems = [
            DemoMapItem(mapItemThumbnailImage: nil, coordinate2D: CLLocationCoordinate2DMake(48.841389, 2.253056), title: "Parc des Princes", address: "24 Rue du Commandant-Guilbaud", thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Paris_Parc_des_Princes_1.jpg/260px-Paris_Parc_des_Princes_1.jpg")!),
            DemoMapItem(mapItemThumbnailImage: nil, coordinate2D: CLLocationCoordinate2DMake(45.765248,  4.981871), title: "Parc Olympique lyonnais", address: "10 avenue Simone-Veil", thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Parc_OL.jpg/260px-Parc_OL.jpg")!)
        ]
    }

    // MARK: - MapDemoViewController

    func flaneurMapViewDidSelect(mapItem: FlaneurMapItem) {
        print("flaneurMapViewDidSelect: ", mapItem)
    }

    @IBAction func toggleWithSpinnerAction(_ sender: Any? = nil) {
        UIView.animate(withDuration: 0.5) { 
            self.mapView.isHidden = !self.mapView.isHidden
            self.spinner.isHidden = !self.spinner.isHidden
        }
    }

    @IBAction func overlayViewAction(_ sender: Any? = nil) {
        let overlay = UIView(frame: .zero)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor(red: 0.0,
                                          green: 1.0,
                                          blue: 0.0,
                                          alpha: 0.5)
        overlay.isOpaque = false
        self.view.addSubview(overlay)

        _ = LayoutBorderManager(item: overlay,
                                toItem: mapView,
                                top: 2.0,
                                left: 4.0,
                                bottom: 6.0,
                                right: 8.0)
    }
}
