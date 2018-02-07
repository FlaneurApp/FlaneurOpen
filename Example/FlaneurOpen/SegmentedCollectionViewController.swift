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
    let collectionView: SegmentedCollectionView = SegmentedCollectionView()
    let padding: CGFloat = 8.0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: padding),
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -padding)
            ])

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
    func segmentedCollectionView(_ collectionView: SegmentedCollectionView, numberOfColumnsForSection section: Int) -> Int {
        return section + 1
    }

    func segmentedCollectionView(_ collectionView: SegmentedCollectionView, heightForItemWithWidth width: CGFloat, forSection: Int) -> CGFloat {
        return 100.0
    }

    func segmentedCollectionView(_ collectionView: SegmentedCollectionView, didSelectItem item: FlaneurCollectionItem) {
        print("select: \(item)")
    }

    func segmentedCollectionView(_ collectionView: SegmentedCollectionView,
                                 heightForItemWithWidth width: CGFloat) -> CGFloat {
        debugPrint("Width: \(width)")
        return 70.0
    }

    func verticalPaddingForItems(in collectionView: SegmentedCollectionView) -> CGFloat {
        return 1.0
    }
}

