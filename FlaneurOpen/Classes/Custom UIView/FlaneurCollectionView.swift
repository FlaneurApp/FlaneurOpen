//
//  FlaneurCollectionView.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 12/09/2017.
//
//

import UIKit
import IGListKit

fileprivate let borderWidth: CGFloat = 9.0
fileprivate let nbColumns: CGFloat = 2.0

public protocol FlaneurCollectionViewDelegate {
    func flaneurCollectionView(_ collectionView: FlaneurCollectionView, didSelectItem item: FlaneurCollectionItem)
}

/// TODO
final public class FlaneurCollectionView: UIView {
    /// The object that acts as the delegate of the collection view.
    ///
    /// The delegate must adopt the `FlaneurCollectionContainerViewDelegate` protocol.
    /// The delegate is not retained.
    public var delegate: FlaneurCollectionViewDelegate? = nil

    /// The filters of the collection view.
    ///
    /// An item will be displayed by the collection view if at least one of the filters returns `true` for it.
    /// When at least one filter is set up, the filtersCollectionView is displayed.
    public var filters: [FlaneurCollectionFilter] = [] {
        didSet {
            itemsListAdapter.performUpdates(animated: true)
        }
    }

    /// The items to display in the collection view
    public var items: [FlaneurCollectionItem] = [] {
        didSet {
            itemsListAdapter.performUpdates(animated: true)
        }
    }

    // The collection view of items (as opposed to the optional collection view for filters).
    let itemsCollectionView: UICollectionView = {
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

    var itemsListAdapter: FlaneurCollectionWithBorderListAdapter!

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
                          items: [FlaneurCollectionItem]) {
        // This prevents an automatic 64pt offset for the status bar + navigation bar.
        viewController.automaticallyAdjustsScrollViewInsets = false

        // Init the adapter
        itemsListAdapter = {
            return FlaneurCollectionWithBorderListAdapter(updater: ListAdapterUpdater(),
                                                          viewController: viewController,
                                                          workingRangeSize: 1,
                                                          borderWidth: borderWidth)
        }()

        self.items = items

        // Setup constraint
        let padding: CGFloat = 0.0
        self.addSubview(itemsCollectionView)
        itemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: itemsCollectionView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: padding).isActive = true
        NSLayoutConstraint(item: itemsCollectionView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -padding).isActive = true
        NSLayoutConstraint(item: itemsCollectionView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: padding).isActive = true
        NSLayoutConstraint(item: itemsCollectionView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -padding).isActive = true

        // Finish setting up things
        itemsListAdapter.collectionView = itemsCollectionView
        itemsListAdapter.dataSource = self
        itemsCollectionView.contentInset = UIEdgeInsets(top: borderWidth / 2.0,
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

    func didSelectFilter(named filterName: String) {
        self.filters = filters.filter { $0.name != filterName }
    }
}

// MARK: - ListAdapterDataSource Extension

extension FlaneurCollectionView: ListAdapterDataSource {
    // MARK: - ListAdapterDataSource Extension

    /// Cf. `IGListKit` documentation
    ///
    /// - Parameter listAdapter: listAdapter
    /// - Returns: items
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if filters.isEmpty {
            return items
        } else {
            // Process each element to see if they're included.
            return items.filter({ item -> Bool in
                guard self.filters.count > 0 else {
                    return true
                }

                for filter in self.filters {
                    if filter.filter(item) {
                        // As soon as one filter includes the item, no need to apply the rest...
                        return true
                    }
                }
                // If we get here, none of the filters included the item: we can exclude it.
                return false
            })
        }
    }

    /// Cf. `IGListKit` documentation
    ///
    /// - Parameters:
    ///   - listAdapter: listAdapter
    ///   - object: object
    /// - Returns: a `FilterableSectionController` instance for the object
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return FilterableSectionController(object: object as! FlaneurCollectionItem,
                                           collectionView: self)
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
