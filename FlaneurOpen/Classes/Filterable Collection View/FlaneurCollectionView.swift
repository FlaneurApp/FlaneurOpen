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
fileprivate let defaultNbColumns: Int = 2
fileprivate let defaultCellSizeRatio: CGFloat = 1.0

fileprivate let filtersViewHeight: CGFloat = 44.0

public protocol FlaneurCollectionViewDelegate {
    func flaneurCollectionView(_ collectionView: FlaneurCollectionView, didSelectItem item: FlaneurCollectionItem)
    func flaneurCollectionView(_ collectionView: FlaneurCollectionView, didDeselectItem item: FlaneurCollectionItem)
    func flaneurCollectionView(_ collectionView: FlaneurCollectionView, didDeselectFilter filter: FlaneurCollectionFilter)
}

public extension FlaneurCollectionViewDelegate where Self: UIViewController {
    func flaneurCollectionView(_ collectionView: FlaneurCollectionView, didSelectItem item: FlaneurCollectionItem) {
        debugPrint("override didSelectItem: to customize behavior")
    }

    func flaneurCollectionView(_ collectionView: FlaneurCollectionView, didDeselectItem item: FlaneurCollectionItem) {
        debugPrint("override didDeselectItem: to customize behavior")
    }

    func flaneurCollectionView(_ collectionView: FlaneurCollectionView, didDeselectFilter filter: FlaneurCollectionFilter) {
        debugPrint("override didDeselectFilter: to customize behavior")
    }
}

/// TODO
final public class FlaneurCollectionView: UIView {
    public var nbColumns: Int = defaultNbColumns
    public var cellSizeRatio: CGFloat = defaultCellSizeRatio

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
            filtersListAdapter.performUpdates(animated: true)
        }
    }

    /// The items to display in the collection view
    public var items: [FlaneurCollectionItem] = [] {
        didSet {
            itemsListAdapter.performUpdates(animated: true)
        }
    }

    // The collection view of items (as opposed to the optional collection view for filters).
    public let itemsCollectionView: UICollectionView = {
        // IGListKit's ListCollectionViewLayout is the only 'cheap' layout option that allows
        // to use IGListKit with a multi-column layout.
        let collectionViewLayout = ListCollectionViewLayout(stickyHeaders: false,
                                                            scrollDirection: .vertical,
                                                            topContentInset: 0.0,
                                                            stretchToEdge: false)

        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .white
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = true

        view.contentInset = UIEdgeInsets(top: borderWidth / 2.0,
                                         left: borderWidth,
                                         bottom: borderWidth / 2.0,
                                         right: borderWidth)

        return view
    }()

    // The collection view of filters (as opposed to the collection view for items).
    let filtersCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .white
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = true

        view.contentInset = UIEdgeInsets(top: borderWidth,
                                         left: borderWidth,
                                         bottom: 0.0,
                                         right: borderWidth)

        return view
    }()

    var itemsListAdapter: FlaneurCollectionWithBorderListAdapter!
    var filtersListAdapter: ListAdapter!

    var itemsCollectionViewTopConstraint: NSLayoutConstraint!

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
                          items: [FlaneurCollectionItem],
                          nbColumns: Int = defaultNbColumns,
                          cellSizeRatio: CGFloat = defaultCellSizeRatio) {
        // This prevents an automatic 64pt offset for the status bar + navigation bar.
        viewController.automaticallyAdjustsScrollViewInsets = false

        // Init the adapter
        itemsListAdapter = {
            return FlaneurCollectionWithBorderListAdapter(updater: ListAdapterUpdater(),
                                                          viewController: viewController,
                                                          workingRangeSize: 1,
                                                          borderWidth: borderWidth)
        }()

        filtersListAdapter = {
            return ListAdapter(updater: ListAdapterUpdater(),
                               viewController: viewController,
                               workingRangeSize: 1)
        }()

        self.items = items

        self.nbColumns = nbColumns
        self.cellSizeRatio = cellSizeRatio

        // Setup constraint
        let padding: CGFloat = 0.0
        self.addSubview(filtersCollectionView)
        self.addSubview(itemsCollectionView)
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        itemsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        // Place the filters collection view on top
        _ = LayoutBorderManager(item: filtersCollectionView,
                                                toItem: self,
                                                top: 0.0,
                                                left: 0.0,
                                                bottom: nil,
                                                right: 0.0)
        NSLayoutConstraint(item: filtersCollectionView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: filtersViewHeight).isActive = true

        // Place the items collection view right underneath
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
        itemsCollectionViewTopConstraint = NSLayoutConstraint(item: itemsCollectionView,
                                                              attribute: .top,
                                                              relatedBy: .equal,
                                                              toItem: self,
                                                              attribute: .top,
                                                              multiplier: 1.0,
                                                              constant: padding)
        itemsCollectionViewTopConstraint.isActive = true
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

        filtersListAdapter.collectionView = filtersCollectionView
        filtersListAdapter.dataSource = self
    }

    // MARK: - Private Code

    /// Common init code.
    func didLoad() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
    }

    func didSelectFilter(_ filterToRemove: FlaneurCollectionFilter) {
        self.filters = filters.filter { $0.name != filterToRemove.name }
        delegate?.flaneurCollectionView(self, didDeselectFilter: filterToRemove)
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
        if listAdapter == itemsListAdapter {
            return itemsObjects()
        } else if listAdapter == filtersListAdapter {
            return filtersObjects()
        } else {
            fatalError("unexpected case")
        }
    }

    func itemsObjects() -> [ListDiffable] {
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

    func filtersObjects() -> [ListDiffable] {
        // Adjust the height of the filtersCollectionView
        let newHeight: CGFloat = filters.isEmpty ? 0.0 : filtersViewHeight
        if itemsCollectionViewTopConstraint.constant != newHeight {
            UIView.animate(withDuration: 5.0,
                           delay: 0.0,
                           animations: {
                            self.itemsCollectionViewTopConstraint.constant = newHeight
            })
        }

        return filters
    }

    /// Cf. `IGListKit` documentation
    ///
    /// - Parameters:
    ///   - listAdapter: listAdapter
    ///   - object: object
    /// - Returns: a `FilterableSectionController` instance for the object
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if listAdapter == itemsListAdapter {
            return FlaneurCollectionItemSectionController(object: object as! FlaneurCollectionItem,
                                                          collectionView: self,
                                                          nbColumns: self.nbColumns,
                                                          cellSizeRatio: self.cellSizeRatio)
        } else if listAdapter == filtersListAdapter {
            return FlaneurCollectionFilterSectionController(object: object as! FlaneurCollectionFilter,
                                                            collectionView: self)
        } else {
            fatalError("unexpected case")
        }
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
