//
//  FilteredCollectionViewDemoViewController.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 11/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import IGListKit

let borderWidth: CGFloat = 0.0

class FilteredCollectionViewDemoViewController: UIViewController {
    // @IBOutlet weak var collectionView: UICollectionView!

    let collectionView: UICollectionView = {
        let collectionViewLayout = ListCollectionViewLayout(stickyHeaders: false,
                                                            topContentInset: 0.0,
                                                            stretchToEdge: false)

        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .green
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = true
        return view
    }()

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(),
                           viewController: self,
                           workingRangeSize: 1)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange

        // This prevents an automatic 64pt offset for the status bar + navigation bar.
        self.automaticallyAdjustsScrollViewInsets = false

        // Constraints
        print("1. contentOffset: ", collectionView.contentOffset)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 1.0).isActive = true
        NSLayoutConstraint(item: collectionView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -1.0).isActive = true
        NSLayoutConstraint(item: collectionView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 65.0).isActive = true
        NSLayoutConstraint(item: collectionView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -1.0).isActive = true

        adapter.collectionView = collectionView
        adapter.dataSource = self
        print("2. contentOffset: ", collectionView.contentOffset)
        collectionView.contentInset = UIEdgeInsets(top: borderWidth / 2.0,
                                                   left: borderWidth,
                                                   bottom: borderWidth / 2.0,
                                                   right: borderWidth)
        print("3. contentOffset: ", collectionView.contentOffset)
    }
}

// MARK: - ListAdapterDataSource Extension

extension FilteredCollectionViewDemoViewController: ListAdapterDataSource {
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var allItems: [ListDiffable] = [
            FilterableDiffable(id: "1", name: "Paris", categories:        ["France",     "Europe"]),
            FilterableDiffable(id: "2", name: "Bordeaux", categories:     ["France",     "Europe"]),
            FilterableDiffable(id: "3", name: "Madrid", categories:       ["Espagne",    "Europe"]),
            FilterableDiffable(id: "4", name: "Barcelone", categories:    ["Espagne",    "Europe"]),
            FilterableDiffable(id: "5", name: "Tokyo", categories:        ["Japon",      "Asie"]),
            FilterableDiffable(id: "6", name: "Ozaka", categories:        ["Japon",      "Asie"]),
            FilterableDiffable(id: "7", name: "New York", categories:     ["États-Unis", "Amériques"]),
            FilterableDiffable(id: "8", name: "Los Angeles", categories:  ["États-Unis", "Amériques"]),
            FilterableDiffable(id: "9", name: "Buenos Aires", categories: ["Argentine",  "Amériques"]),
            FilterableDiffable(id: "10", name: "Brasilia", categories:    ["Brésil",     "Amériques"]),
            FilterableDiffable(id: "11", name: "Dakar", categories:       ["Sénagal",    "Afrique"]),
            FilterableDiffable(id: "21", name: "Paris", categories:        ["France",     "Europe"]),
            FilterableDiffable(id: "22", name: "Bordeaux", categories:     ["France",     "Europe"]),
            FilterableDiffable(id: "23", name: "Madrid", categories:       ["Espagne",    "Europe"]),
            FilterableDiffable(id: "24", name: "Barcelone", categories:    ["Espagne",    "Europe"]),
            FilterableDiffable(id: "25", name: "Tokyo", categories:        ["Japon",      "Asie"]),
            FilterableDiffable(id: "26", name: "Ozaka", categories:        ["Japon",      "Asie"]),
            FilterableDiffable(id: "27", name: "New York", categories:     ["États-Unis", "Amériques"]),
            FilterableDiffable(id: "28", name: "Los Angeles", categories:  ["États-Unis", "Amériques"]),
            FilterableDiffable(id: "29", name: "Buenos Aires", categories: ["Argentine",  "Amériques"]),
            FilterableDiffable(id: "30", name: "Brasilia", categories:    ["Brésil",     "Amériques"]),
            FilterableDiffable(id: "31", name: "Dakar", categories:       ["Sénagal",    "Afrique"]),
            ]
        return allItems
    }

    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return FilterableSectionController(object: object as! FilterableDiffable)
    }

    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }
}

extension ListAdapter: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(borderWidth / 2.0, 0, borderWidth / 2.0, 0)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return borderWidth
    }
}


class FilterableDiffable: ListDiffable {
    let id: String
    let name: String
    let categories: [String]

    init(id: String, name: String, categories: [String]) {
        self.id = id
        self.name = name
        self.categories = categories
    }

    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: id)
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? FilterableDiffable {
            return self.id == object.id
        } else {
            return false
        }
    }
}

class FilterableSectionController: ListSectionController {
    var object: FilterableDiffable

    init(object: FilterableDiffable) {
        self.object = object
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }

        let nbColumns: CGFloat = 4.0
        let squareSize = (context.containerSize.width - (2.0 + nbColumns - 1.0) * borderWidth) / nbColumns
        print("contextSize: ", context.containerSize)
        print("squareSize: ", squareSize)

        return CGSize(width: squareSize, height: squareSize)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: "DemoCollectionViewCell",
                                                          bundle: nil,
                                                          for: self,
                                                          at: index) as! DemoCollectionViewCell

        cell.backgroundColor = .blue
        cell.label.text = object.name
        cell.clipsToBounds = true

        return cell
    }
}
