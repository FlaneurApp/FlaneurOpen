//
//  GrayscalingViewController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 30/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen
import MapKit

class GrayscalingViewController: UIViewController {
    let snapshotImageView = UIImageView()
    let mapView = MKMapView()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setRegion(.greaterBostonArea, animated: false)
        mapView.delegate = self

        view.addSubview(mapView)
        view.addSubview(snapshotImageView)

        label.backgroundColor = .darkGray
        label.textColor = .white
        label.text = "Check out the logs in Xcode to get details about the map view's region."
        label.numberOfLines = 0
        view.addSubview(label)

        // Constraints
        snapshotImageView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        let snapshotRatio: CGFloat = 0.20
        NSLayoutConstraint.activate([
            snapshotImageView.topAnchor.constraint(equalTo: mapView.topAnchor),
            snapshotImageView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            snapshotImageView.widthAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: snapshotRatio),
            snapshotImageView.heightAnchor.constraint(equalTo: mapView.heightAnchor, multiplier: snapshotRatio),
            snapshotImageView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: label.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.snapshot { snapshot, error in
            guard let image = snapshot?.image else {
                debugPrint("No image available")
                return
            }

            self.snapshotImageView.image = image.withGrayscaleFilter()
        }
    }
}

extension GrayscalingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("mapView.region.center: ", mapView.region.center)
        print("mapView.region.span: ", mapView.region.span)
    }
}
