//
//  FilteredCollectionViewDemoViewController.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 11/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen
import IGListKit

class FilterableLocation: FlaneurDiffable {
    let id: String
    let name: String
    let categories: [String]

    var nibName: String {
        return "DemoCollectionViewCell"
    }

    func configureCell(cell: UICollectionViewCell) {
        if let cell = cell as? DemoCollectionViewCell {
            cell.label.text = name
            cell.backgroundColor = .blue
        }
    }

    init(id: String, name: String, categories: [String]) {
        self.id = id
        self.name = name
        self.categories = categories
    }

    public func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: id)
    }

    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? FilterableLocation {
            return self.id == object.id
        } else {
            return false
        }
    }
}

class FilteredCollectionViewDemoViewController: UIViewController {
    @IBOutlet weak var collectionViewContainer: FlaneurCollectionContainerView!

    let allItems = [
        FilterableLocation(id: "1", name: "Paris", categories:        ["France",     "Europe"]),
        FilterableLocation(id: "2", name: "Bordeaux", categories:     ["France",     "Europe"]),
        FilterableLocation(id: "3", name: "Madrid", categories:       ["Espagne",    "Europe"]),
        FilterableLocation(id: "4", name: "Barcelone", categories:    ["Espagne",    "Europe"]),
        FilterableLocation(id: "5", name: "Tokyo", categories:        ["Japon",      "Asie"]),
        FilterableLocation(id: "6", name: "Ozaka", categories:        ["Japon",      "Asie"]),
        FilterableLocation(id: "7", name: "New York", categories:     ["États-Unis", "Amériques"]),
        FilterableLocation(id: "8", name: "Los Angeles", categories:  ["États-Unis", "Amériques"]),
        FilterableLocation(id: "9", name: "Buenos Aires", categories: ["Argentine",  "Amériques"]),
        FilterableLocation(id: "10", name: "Brasilia", categories:    ["Brésil",     "Amériques"]),
        FilterableLocation(id: "11", name: "Dakar", categories:       ["Sénagal",    "Afrique"]),
        FilterableLocation(id: "21", name: "Paris", categories:        ["France",     "Europe"]),
        FilterableLocation(id: "22", name: "Bordeaux", categories:     ["France",     "Europe"]),
        FilterableLocation(id: "23", name: "Madrid", categories:       ["Espagne",    "Europe"]),
        FilterableLocation(id: "24", name: "Barcelone", categories:    ["Espagne",    "Europe"]),
        FilterableLocation(id: "25", name: "Tokyo", categories:        ["Japon",      "Asie"]),
        FilterableLocation(id: "26", name: "Ozaka", categories:        ["Japon",      "Asie"]),
        FilterableLocation(id: "27", name: "New York", categories:     ["États-Unis", "Amériques"]),
        FilterableLocation(id: "28", name: "Los Angeles", categories:  ["États-Unis", "Amériques"]),
        FilterableLocation(id: "29", name: "Buenos Aires", categories: ["Argentine",  "Amériques"]),
        FilterableLocation(id: "30", name: "Brasilia", categories:    ["Brésil",     "Amériques"]),
        FilterableLocation(id: "31", name: "Dakar", categories:       ["Sénagal",    "Afrique"]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange

        collectionViewContainer.configure(viewController: self, items: allItems)
        collectionViewContainer.delegate = self
    }
}

extension FilteredCollectionViewDemoViewController: FlaneurCollectionContainerViewDelegate {
    func collectionContainerViewDidSelectItem(_ item: Any) {
        debugPrint("didSelect: ", item)
    }
}
