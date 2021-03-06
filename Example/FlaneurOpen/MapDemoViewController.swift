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

final class MapDemoViewController: UIViewController, FlaneurMapViewDelegate {
    let mapView: FlaneurMapView = FlaneurMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])

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
}
