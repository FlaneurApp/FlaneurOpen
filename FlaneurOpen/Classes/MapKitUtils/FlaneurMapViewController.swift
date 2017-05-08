//
//  FlaneurMapViewController.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 04/05/2017.
//
//

import MapKit
import SDWebImage

public protocol FlaneurMapItem {
    var mapItemCoordinate2D: CLLocationCoordinate2D { get }
    var mapItemTitle: String? { get }
    var mapItemAddress: String? { get }
    var mapItemThumbnailURL: URL? { get }
    var mapItemThumbnailImage: UIImage? { get }
}

public protocol FlaneurMapViewDelegate {
    func flaneurMapViewControllerDidSelect(mapItem: FlaneurMapItem)
}

class FlaneurMapAnnotation: MKPointAnnotation {
    let mapItem: FlaneurMapItem

    init(mapItem: FlaneurMapItem) {
        self.mapItem = mapItem

        super.init()

        coordinate = mapItem.mapItemCoordinate2D
        title = mapItem.mapItemTitle
        subtitle = mapItem.mapItemAddress
    }
}

public class FlaneurMapViewController: UIViewController {
    @IBOutlet public weak var mapView: MKMapView?
    public var delegate: FlaneurMapViewDelegate?
    public var mapItems: [FlaneurMapItem] = []
    public var annotationImage: UIImage? = UIImage(named: "FlaneurMapViewControllerAnnotationImage")
    public var rightCalloutImage: UIImage? = UIImage(named: "FlaneurMapViewControllerRightCalloutImage")
    public var leftCalloutPlaceholderImage: UIImage? = UIImage(named: "FlaneurMapViewControllerLeftCalloutPlaceholderImage")

    override public func viewDidLoad() {
        super.viewDidLoad()

        if mapView == nil {
            mapView = MKMapView(frame: CGRect(origin: .zero,
                                              size: self.view.frame.size))
            self.view.addSubview(mapView!)
        }

        if let myView = mapView {
            // Functional config of the map view
            myView.showsUserLocation = true
            myView.delegate = self
        }
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadAnnotations()
    }

    func reloadAnnotations() {
        if let mapView = mapView {
            mapView.removeAnnotations(mapView.annotations)
            let annotations = mapItems.map { FlaneurMapAnnotation(mapItem: $0) }
            mapView.showAnnotations(annotations, animated: true)
        }
    }
}

extension FlaneurMapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let annotationIdentifier = "FlaneurMapAnnotation"
            let myAnnotation = annotation as! FlaneurMapAnnotation

            let annotationView = MKAnnotationView(annotation: myAnnotation, reuseIdentifier: annotationIdentifier)
            annotationView.canShowCallout = true
            annotationView.image = annotationImage

            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true

            // TODO: transform in a switch
            if let image = myAnnotation.mapItem.mapItemThumbnailImage {
                imageView.image = image
            } else if let imageURL = myAnnotation.mapItem.mapItemThumbnailURL {
                imageView.sd_setImage(with: imageURL, placeholderImage: leftCalloutPlaceholderImage)
            } else {
                imageView.image = leftCalloutPlaceholderImage
            }

            annotationView.leftCalloutAccessoryView = imageView

            let calloutButton = UIButton(type: .detailDisclosure)
            calloutButton.setImage(self.rightCalloutImage, for: .normal)
            calloutButton.imageView?.contentMode = .scaleAspectFit
            calloutButton.frame = CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0)
            annotationView.rightCalloutAccessoryView = calloutButton

            return annotationView
        }
    }

    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? FlaneurMapAnnotation {
            delegate?.flaneurMapViewControllerDidSelect(mapItem: annotation.mapItem)
        }
    }
}
