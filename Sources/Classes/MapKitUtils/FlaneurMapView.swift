//
//  FlaneurMapView.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 04/05/2017.
//
//

import MapKit
import Kingfisher

/// The protocol to implement to get callbacks from a `FlaneurMapView` instance.
public protocol FlaneurMapViewDelegate: AnyObject {
    /// Tells the delegate that the specified map item's annotation callout was tapped.
    ///
    /// - Parameter mapItem: the map item for which the annotation was tapped
    func flaneurMapViewDidSelect(mapItem: FlaneurMapItem)

    /// Tells the delegate that the specified map view successfully loaded the needed map data.
    ///
    /// - Parameters:
    ///   - mapView: The map view that started the load operation.
    func flaneurMapViewDidFinishLoadingMap(_ mapView: FlaneurMapView)
}

/// Utility class to display a map view with annotations with very little effort.
open class FlaneurMapView: UIView {
    fileprivate var mapView = MKMapView(frame: .zero)

    // MARK: - Locations data & receiving events

    /// The receiver’s delegate.
    public weak var delegate: FlaneurMapViewDelegate?

    /// The items to display on the map.
    public var mapItems: [FlaneurMapItem] = [] {
        didSet {
            self.reloadAnnotations()
        }
    }

    // MARK: - Customizing annotations

    /// A Boolean value indicating whether the map should try to display the user’s location.
    public var showsUserLocation = true {
        didSet {
            mapView.showsUserLocation = showsUserLocation
        }
    }

    /// The image displayed
    public var annotationImage: UIImage? = UIImage(named: "FlaneurMapViewControllerAnnotationImage")

    /// The right image to display on the annotation for each item
    public var rightCalloutImage: UIImage? = UIImage(named: "FlaneurMapViewControllerRightCalloutImage")

    /// The left image to display on the annotation for each item
    public var leftCalloutPlaceholderImage: UIImage? = UIImage(named: "FlaneurMapViewControllerLeftCalloutPlaceholderImage")

    // MARK: - Lifecycle

    /// Initializes and returns a newly allocated map view object
    /// with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    /// Not implemented.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didLoad()
    }

    private func didLoad() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        mapView.delegate = self
        showsUserLocation = true
    }

    // MARK: - Reloading annotations

    func reloadAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = mapItems.map { FlaneurMapAnnotation(mapItem: $0) }
        mapView.showAnnotations(annotations, animated: true)
    }
}

extension FlaneurMapView: MKMapViewDelegate {
    // MARK: - MKMapViewDelegate

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
                imageView.kf.setImage(with: imageURL, placeholder: leftCalloutPlaceholderImage)
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
            delegate?.flaneurMapViewDidSelect(mapItem: annotation.mapItem)
        }
    }

    /// Overriden
    public func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        debugPrint("mapViewWillStartLoadingMap")
    }

    /// Overriden
    public func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        delegate?.flaneurMapViewDidFinishLoadingMap(self)
    }

    /// Overriden
    public func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("ERROR: \(error)")
    }
}

public extension FlaneurMapViewDelegate {
    func flaneurMapViewDidFinishLoadingMap(_ mapView: FlaneurMapView) {
        debugPrint("mapViewDidFinishLoadingMap")
    }
}
