//
//  FlaneurMapViewController.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 04/05/2017.
//
//

import MapKit
import SDWebImage

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

/// The protocol to implement to get callbacks from a `FlaneurMapViewController` instance.
@objc public protocol FlaneurMapViewDelegate {
    /// Tells the delegate that the specified map item's annotation callout was tapped.
    ///
    /// - Parameter mapItem: the map item for which the annotation was tapped
    func flaneurMapViewControllerDidSelect(mapItem: FlaneurMapItem)
}

public class FlaneurMapAnnotation: MKPointAnnotation {
    let mapItem: FlaneurMapItem

    public init(mapItem: FlaneurMapItem) {
        self.mapItem = mapItem

        super.init()

        coordinate = mapItem.mapItemCoordinate2D
        title = mapItem.mapItemTitle
        subtitle = mapItem.mapItemAddress
    }
}

/// Utility class to display a map view with annotations with very little effort.
///
/// ## Overview
///
/// A map view controller bla bla bla
open class FlaneurMapViewController: UIViewController {
    /// The map view (useful only if a Storyboard is used)
    @IBOutlet public weak var mapView: MKMapView?

    /// The delegate
    public var delegate: FlaneurMapViewDelegate?

    /// The items to display on the map
    public var mapItems: [FlaneurMapItem] = []

    /// The image diplayed
    public var annotationImage: UIImage? = UIImage(named: "FlaneurMapViewControllerAnnotationImage")

    // MARK: - Customizing annotations

    /// The right image to display on the annotation for each item
    public var rightCalloutImage: UIImage? = UIImage(named: "FlaneurMapViewControllerRightCalloutImage")

    /// The left image to display on the annotation for each item
    public var leftCalloutPlaceholderImage: UIImage? = UIImage(named: "FlaneurMapViewControllerLeftCalloutPlaceholderImage")

    // MARK: - UIViewController life cycle

    /// Overriden
    override open func viewDidLoad() {
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

    /// Overriden
    override open func viewDidAppear(_ animated: Bool) {
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
    /// Overriden
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

    /// Overriden
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? FlaneurMapAnnotation {
            delegate?.flaneurMapViewControllerDidSelect(mapItem: annotation.mapItem)
        }
    }
}
