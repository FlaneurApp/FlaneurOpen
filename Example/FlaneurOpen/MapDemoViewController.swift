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

struct DemoMapItem: FlaneurMapItem {
    var mapItemThumbnailImage: UIImage? = nil

    let coordinate2D: CLLocationCoordinate2D
    let title: String
    let address: String
    let thumbnailURL: URL

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
    @IBOutlet weak var mapView: UIView!

    var mapViewController: FlaneurMapViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        UIButton.appearance(whenContainedInInstancesOf: [MKAnnotationView.self]).tintColor = .green
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapViewEmbed" {
            self.mapViewController = segue.destination as? FlaneurMapViewController
            self.mapViewController?.delegate = self
            self.mapViewController?.annotationImage = UIImage(named: "sample-908-target")
            self.mapViewController?.rightCalloutImage = UIImage(named: "sample-321-like")?.withRenderingMode(.alwaysTemplate)
            self.mapViewController?.leftCalloutPlaceholderImage = UIImage(named: "sample-908-target")
            self.mapViewController?.mapItems = [
                DemoMapItem(mapItemThumbnailImage: nil, coordinate2D: CLLocationCoordinate2DMake(48.841389, 2.253056), title: "Parc des Princes", address: "24 Rue du Commandant-Guilbaud", thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Paris_Parc_des_Princes_1.jpg/260px-Paris_Parc_des_Princes_1.jpg")!),
                DemoMapItem(mapItemThumbnailImage: nil, coordinate2D: CLLocationCoordinate2DMake(45.765248,  4.981871), title: "Parc Olympique lyonnais", address: "10 avenue Simone-Veil", thumbnailURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Parc_OL.jpg/260px-Parc_OL.jpg")!)
            ]
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - FlaneurMapViewDelegate

    func flaneurMapViewControllerDidSelect(mapItem: FlaneurMapItem) {
        print("flaneurMapViewControllerDidSelect", mapItem)
    }
}
