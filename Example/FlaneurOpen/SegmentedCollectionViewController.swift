//
//  SegmentedCollectionViewController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 11/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen

class SegmentedCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: SegmentedCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        collectionView.itemsSections = [
            SegmentedCollectionSection(title: "Europe",
                                       items: [
                                        FilterableLocation(id: "1", name: "Paris", categories:        ["France",     "Europe"]),
                                        FilterableLocation(id: "2", name: "Bordeaux", categories:     ["France",     "Europe"]),
                                        FilterableLocation(id: "3", name: "Madrid", categories:       ["Spain",    "Europe"]),
                                        FilterableLocation(id: "4", name: "Barcelone", categories:    ["Spain",    "Europe"]),
                                        FilterableLocation(id: "21", name: "Nantes", categories:        ["France",     "Europe"]),
                                        FilterableLocation(id: "22", name: "Marseille", categories:     ["France",     "Europe"]),
                                        FilterableLocation(id: "23", name: "Gijon", categories:       ["Spain",    "Europe"]),
                                        FilterableLocation(id: "24", name: "Valencia", categories:    ["Spain",    "Europe"]),
                                        ]),
            SegmentedCollectionSection(title: "Americas",
                                       items: [
                                        FilterableLocation(id: "7", name: "New York", categories:     ["États-Unis", "Amériques"]),
                                        FilterableLocation(id: "8", name: "Los Angeles", categories:  ["États-Unis", "Amériques"]),
//                                        FilterableLocation(id: "9", name: "Buenos Aires", categories: ["Argentine",  "Amériques"]),
//                                        FilterableLocation(id: "10", name: "Brasilia", categories:    ["Brésil",     "Amériques"]),
//                                        FilterableLocation(id: "27", name: "Boston", categories:     ["États-Unis", "Amériques"]),
//                                        FilterableLocation(id: "28", name: "Houston", categories:  ["États-Unis", "Amériques"]),
//                                        FilterableLocation(id: "29", name: "Rosario", categories: ["Argentine",  "Amériques"]),
//                                        FilterableLocation(id: "30", name: "Rio de Janeiro", categories:    ["Brésil",     "Amériques"]),
                                        ]),
            SegmentedCollectionSection(title: "Others",
                                       items: [
                                        FilterableLocation(id: "5", name: "Tokyo", categories:        ["Japon",      "Asie"]),
                                        FilterableLocation(id: "6", name: "Ozaka", categories:        ["Japon",      "Asie"]),
                                        FilterableLocation(id: "11", name: "Dakar", categories:       ["Sénégal",    "Afrique"]),
                                        FilterableLocation(id: "25", name: "Nagano", categories:        ["Japon",      "Asie"]),
                                        FilterableLocation(id: "26", name: "Fukushima", categories:        ["Japon",      "Asie"]),
                                        FilterableLocation(id: "31", name: "Saint-Louis", categories:       ["Sénégal",    "Afrique"]),
                                        ]),
        ]

        let myHeaderView = UIImageView(frame: .zero)
        myHeaderView.image = UIImage(named: "radial-gradient")
        myHeaderView.contentMode = .scaleAspectFill
        collectionView.headerView = myHeaderView

        collectionView.delegate = self
    }
}

extension SegmentedCollectionViewController: SegmentedCollectionViewDelegate {
    func segmentedCollectionView(_ collectionView: SegmentedCollectionView, didSelectItem item: FlaneurCollectionItem) {
        print("select: \(item)")
    }
}

