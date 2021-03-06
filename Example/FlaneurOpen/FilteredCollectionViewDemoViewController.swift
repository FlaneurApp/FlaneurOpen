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

class FilterableLocation: FlaneurCollectionItem, ListDiffable {
    let id: String
    let name: String
    let categories: [String]

    var cellStyle: FlaneurCollectionItemCellStyle {
        return .nibName(nibName: "DemoCollectionViewCell")
    }

    func configureCell(cell: UICollectionViewCell) {
        if let cell = cell as? DemoCollectionViewCell {
            cell.updateBackgroundColorFromSelection()
            cell.label.text = name
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
            return self == object
        } else {
            return false
        }
    }
}

extension FilterableLocation: Equatable {
    static func == (lhs: FilterableLocation, rhs: FilterableLocation) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
    }
}

extension FilterableLocation: CustomStringConvertible {
    var description: String {
        return "(\(id); \(name))"
    }
}

class FilteredCollectionViewDemoViewController: UIViewController {
    @IBOutlet weak var collectionViewContainer: FlaneurCollectionView!

    var allItems = [
        FilterableLocation(id: "1", name: "Paris", categories:        ["France",     "Europe"]),
        FilterableLocation(id: "2", name: "Bordeaux", categories:     ["France",     "Europe"]),
        FilterableLocation(id: "3", name: "Madrid", categories:       ["Spain",    "Europe"]),
        FilterableLocation(id: "4", name: "Barcelone", categories:    ["Spain",    "Europe"]),
        FilterableLocation(id: "5", name: "Tokyo", categories:        ["Japon",      "Asie"]),
        FilterableLocation(id: "6", name: "Ozaka", categories:        ["Japon",      "Asie"]),
        FilterableLocation(id: "7", name: "New York", categories:     ["États-Unis", "Amériques"]),
        FilterableLocation(id: "8", name: "Los Angeles", categories:  ["États-Unis", "Amériques"]),
        FilterableLocation(id: "9", name: "Buenos Aires", categories: ["Argentine",  "Amériques"]),
        FilterableLocation(id: "10", name: "Brasilia", categories:    ["Brésil",     "Amériques"]),
        FilterableLocation(id: "11", name: "Dakar", categories:       ["Sénégal",    "Afrique"]),
        FilterableLocation(id: "21", name: "Nantes", categories:        ["France",     "Europe"]),
        FilterableLocation(id: "22", name: "Marseille", categories:     ["France",     "Europe"]),
        FilterableLocation(id: "23", name: "Gijon", categories:       ["Spain",    "Europe"]),
        FilterableLocation(id: "24", name: "Valencia", categories:    ["Spain",    "Europe"]),
        FilterableLocation(id: "25", name: "Nagano", categories:        ["Japon",      "Asie"]),
        FilterableLocation(id: "26", name: "Fukushima", categories:        ["Japon",      "Asie"]),
        FilterableLocation(id: "27", name: "Boston", categories:     ["États-Unis", "Amériques"]),
        FilterableLocation(id: "28", name: "Houston", categories:  ["États-Unis", "Amériques"]),
        FilterableLocation(id: "29", name: "Rosario", categories: ["Argentine",  "Amériques"]),
        FilterableLocation(id: "30", name: "Rio de Janeiro", categories:    ["Brésil",     "Amériques"]),
        FilterableLocation(id: "31", name: "Saint-Louis", categories:       ["Sénégal",    "Afrique"]),
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange

        self.navigationItem.title = "Filtered Collection Demo"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentActions))

        collectionViewContainer.configure(viewController: self, items: allItems, nbColumns: 2)
        collectionViewContainer.itemsCollectionView.allowsMultipleSelection = true
        collectionViewContainer.delegate = self
    }

    @IBAction func presentActions(_ sender: Any? = nil) {
        let alertVC = UIAlertController(title: "Pick your option",
                                        message: "Toto",
                                        preferredStyle: .actionSheet)

        let showAllAction = UIAlertAction(title: "Show all", style: .default) { _ in
            self.collectionViewContainer.filters = []
        }
        let filterFranceAction = UIAlertAction(title: "Add France filter", style: .default) { _ in
            self.collectionViewContainer.filters.append(FlaneurCollectionFilter(name: "France",
                                                                                rightImage: UIImage(named: "sample-821-stamp")!) { element in
                                                                                    if let object = element as? FilterableLocation {
                                                                                        return object.categories.contains("France")
                                                                                    } else {
                                                                                        return false
                                                                                    }
            })
        }
        let filterSpainAction = UIAlertAction(title: "Add Spain filter", style: .default) { _ in
            self.collectionViewContainer.filters.append(FlaneurCollectionFilter(name: "Spain",
                                                                                rightImage: UIImage(named: "sample-1082-merge")!) { element in
                                                                                    if let object = element as? FilterableLocation {
                                                                                        return object.categories.contains("Spain")
                                                                                    } else {
                                                                                        return false
                                                                                    }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }

        let changeItemAction = UIAlertAction(title: "Change item", style: .default) { _ in
            self.allItems.remove(at: 0)
            self.allItems.insert(FilterableLocation(id: "1", name: "Brest", categories:        ["France",     "Europe"]), at: 0)
            self.collectionViewContainer.items = self.allItems
        }

        for action in [showAllAction,
                       filterFranceAction,
                       filterSpainAction,
                       changeItemAction,
                       cancelAction] {
                        alertVC.addAction(action)
        }
        self.present(alertVC, animated: true)
    }
}

extension FilteredCollectionViewDemoViewController: FlaneurCollectionViewDelegate {
    // Override stuff here if necessary
}
