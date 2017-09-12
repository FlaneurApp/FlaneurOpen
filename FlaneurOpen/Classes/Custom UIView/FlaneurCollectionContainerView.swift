//
//  FlaneurCollectionContainerView.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 12/09/2017.
//
//

import UIKit
import IGListKit

fileprivate let borderWidth: CGFloat = 9.0
fileprivate let nbColumns: CGFloat = 2.0

/// Convenience protocol for objects featured in a `IGListKit` collection view
public protocol FlaneurDiffable: ListDiffable {
    /// The nib name to use for the cell. It will also be used as a reusable cell identifier.
    var nibName: String { get }

    /// Configures the cell
    ///
    /// - Parameter cell: a cell from the NIB file given by `nibName`.
    func configureCell(cell: UICollectionViewCell)
}

public protocol FlaneurCollectionContainerViewDelegate {
    func collectionContainerViewDidSelectItem(_ item: Any)
}

/// TODO
final public class FlaneurCollectionContainerView: UIView {
    let collectionView: UICollectionView = {
        // IGListKit's ListCollectionViewLayout is the only 'cheap' layout option that allows
        // to use IGListKit with a multi-column layout.
        let collectionViewLayout = ListCollectionViewLayout(stickyHeaders: false,
                                                            topContentInset: 0.0,
                                                            stretchToEdge: false)
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .white
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = true
        return view
    }()

    var adapter: ListAdapter!
    var items: [ListDiffable] = []
    public var delegate: FlaneurCollectionContainerViewDelegate? = nil

    /// Initializes and returns a newly allocated collection container object
    /// with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter coder: An unarchiver object.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didLoad()
    }

    // MARK: - Configuring the bar

    /// TODO
    ///
    /// - Parameters:
    ///   - viewController: TODO
    ///   - items: TODO
    public func configure(viewController: UIViewController,
                          items: [ListDiffable]) {
        // This prevents an automatic 64pt offset for the status bar + navigation bar.
        viewController.automaticallyAdjustsScrollViewInsets = false


        self.items = items

        // Init the adapter
        adapter = {
            return ListAdapter(updater: ListAdapterUpdater(),
                               viewController: viewController,
                               workingRangeSize: 1)
        }()

        // Setup constraint
        let padding: CGFloat = 0.0
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: padding).isActive = true
        NSLayoutConstraint(item: collectionView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -padding).isActive = true
        NSLayoutConstraint(item: collectionView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: padding).isActive = true
        NSLayoutConstraint(item: collectionView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -padding).isActive = true

        // Finish setting up things
        adapter.collectionView = collectionView
        adapter.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: borderWidth / 2.0,
                                                   left: borderWidth,
                                                   bottom: borderWidth / 2.0,
                                                   right: borderWidth)
    }

    // MARK: - Private Code

    /// Common init code.
    func didLoad() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
    }
}

// MARK: -

extension FlaneurCollectionContainerView: ListAdapterDataSource {
    // MARK: - ListAdapterDataSource Extension

    /// Cf. `IGListKit` documentation
    ///
    /// - Parameter listAdapter: listAdapter
    /// - Returns: items
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }

    /// Cf. `IGListKit` documentation
    ///
    /// - Parameters:
    ///   - listAdapter: listAdapter
    ///   - object: object
    /// - Returns: a `FilterableSectionController` instance for the object
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return FilterableSectionController(object: object as! FlaneurDiffable,
                                           collectionContainerView: self)
    }

    /// Cf. `IGListKit` documentation
    ///
    /// - Parameter listAdapter: listAdapter
    /// - Returns: a white large animated spinner
    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }
}

// MARK: - ListSectionController

class FilterableSectionController: ListSectionController {
    let object: FlaneurDiffable
    weak var collectionContainerView: FlaneurCollectionContainerView?

    init(object: FlaneurDiffable,
         collectionContainerView: FlaneurCollectionContainerView) {
        self.object = object
        self.collectionContainerView = collectionContainerView
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }

        let squareSize = (context.containerSize.width - (2.0 + nbColumns - 1.0) * borderWidth) / nbColumns

        return CGSize(width: squareSize, height: squareSize)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: object.nibName,
                                                          bundle: nil,
                                                          for: self,
                                                          at: index)

        object.configureCell(cell: cell)

        return cell
    }

    override func didSelectItem(at index: Int) {
        collectionContainerView?.delegate?.collectionContainerViewDidSelectItem(object)
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
