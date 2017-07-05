//
//  GooglePlacesDemoViewController.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 24/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import GooglePlaces

class GooglePlacesDemoViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var consoleTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if GMSPlacesClient.provideAPIKey("---") {
            debugPrint("OK")
        } else {
            debugPrint("NOK -- Unauthorized")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func filter(withIndex segmentIndex: Int) -> GMSAutocompleteFilter {
        let filter = GMSAutocompleteFilter()

        switch segmentIndex {
        case 0:
            filter.type = .address
        case 1:
            filter.type = .city
        case 2:
            filter.type = .establishment
        case 3:
            filter.type = .geocode
        case 4:
            filter.type = .noFilter
        case 5:
            filter.type = .region
        default:
            debugPrint("Invalid index \(segmentIndex)")
        }

        return filter
    }

    func log(_ logMessage: String) {
        consoleTextView.text = logMessage
    }

    func appendLog(_ logMessage: String) {
        consoleTextView.text = consoleTextView.text + "\n---\n" + logMessage
    }

    @IBAction func searchAction(_ sender: Any) {
        if let queryString = searchBar.text {
            log("Searching for \(queryString)...")
            let autocompleteFilter = filter(withIndex: filterSegmentedControl.selectedSegmentIndex)
            GMSPlacesClient.shared().autocompleteQuery(queryString,
                                                       bounds: nil,
                                                       filter: autocompleteFilter) { (results, error) in
                                                        if let error = error {
                                                            self.log("Autocomplete error:\n\(error)")
                                                            return
                                                        }

                                                        if let results = results {
                                                            self.log("Found \(results.count) results")
                                                            for result in results {
                                                                self.appendLog("Result \(result.attributedFullText) with placeID \(result.placeID)")
                                                            }
                                                        }
            }
        } else {
            log("Can't search empty string")
        }
    }
}
