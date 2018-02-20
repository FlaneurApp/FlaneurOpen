//
//  ListKitDemoViewController.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 10/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import IGListKit
import FlaneurOpen

class MySectionController: ListSectionController {
    var item: UnsplashItem?

    override public func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 120.0)
    }

    func load(callback: @escaping ((Result<Data>) -> ())) {
        URLSession.shared.downloadTask(with: item!.imageURL) { (fileURL, response, error) in
            sleep(5)
            guard let fileURL = fileURL else {
                return callback(Result<Data>(nil, or: error!))
            }
            debugPrint("fileURL", fileURL)
            let data = try! Data(contentsOf: fileURL)
            debugPrint("data", data)
            callback(Result<Data>(data, or: nil))
        }.resume()
    }

    override public func cellForItem(at index: Int) -> UICollectionViewCell {
        let myCell = collectionContext?.dequeueReusableCell(of: LoadingCollectionViewCell.self,
                                                            for: self,
                                                            at: index) as! LoadingCollectionViewCell

        myCell.configure(load: load) { (result) -> UICollectionViewCell in
            let myCell = self.collectionContext!.dequeueReusableCell(withNibName: "DemoCollectionViewCell",
                                                                     bundle: nil,
                                                                     for: self,
                                                                     at: index) as! DemoCollectionViewCell
            switch result {
            case .success(let data):
                if let myImage = UIImage(data: data) {
                    myCell.imageView.image = myImage
                } else {
                    myCell.imageView.image = #imageLiteral(resourceName: "sample-02-redo")
                }

                return myCell
            case .error(_):
                myCell.imageView.image = #imageLiteral(resourceName: "sample-305-palm-tree")
                return myCell
            }
        }

        return myCell
    }

    override func didUpdate(to object: Any) {
        if object is UnsplashItem {
            item = object as? UnsplashItem
        }
    }
}

class UnsplashItem: ListDiffable {
    var format: String
    var width: Int
    var height: Int
    var id: Int
    var author: String
    var postURL: URL

    init(format: String, width: Int, height: Int, id: Int, author: String, postURL: URL) {
        self.format = format
        self.width = width
        self.height = height
        self.id = id
        self.author = author
        self.postURL = postURL
    }

    func diffIdentifier() -> NSObjectProtocol {
        return NSNumber(integerLiteral: id)
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? UnsplashItem {
            return self.postURL == object.postURL
        }
        return false
    }

    var imageURL: URL {
        return URL(string: "https://unsplash.it/200/300?image=\(self.id)")!
    }
}


class ListKitDemoViewController: UIViewController, ListAdapterDataSource {
    @IBOutlet weak var collectionView: UICollectionView!

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(),
                           viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

    // MARK: IGListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [
            UnsplashItem(format: "jpeg", width: 5616, height: 3744, id: 0, author: "Alejandro Escamilla", postURL: URL(string: "https://unsplash.com/photos/yC-Yzbqy7PY")!),
            UnsplashItem(format: "jpeg", width: 5616, height: 3744, id: 1, author: "Alejandro Escamilla", postURL: URL(string: "https://unsplash.com/photos/LNRyGwIJr5c")!)
        ]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return MySectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
