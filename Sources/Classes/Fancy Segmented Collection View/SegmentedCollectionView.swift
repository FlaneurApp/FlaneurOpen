//
//  SegmentedCollectionView.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 11/10/2017.
//

import UIKit
import IGListKit

fileprivate let gutterWidth: CGFloat = 9.0
fileprivate let segmentControlHeight: CGFloat = 65.0

fileprivate let defaultVerticalPaddingForItems: CGFloat = 9.0
fileprivate let defaultNumberOfColumns: Int = 2
fileprivate let defaultHeaderViewHeight: CGFloat = 306.0

/// A collection of items for a `SegmentedCollectionView`.
public struct SegmentedCollectionSection {
    let title: String
    let items: [FlaneurCollectionItem]

    /// Initializes and returns a newly allocated section.
    ///
    /// - Parameters:
    ///   - title: the title of the section. It will appear on the section control.
    ///   - items: the collection of items for the section.
    public init(title: String, items: [FlaneurCollectionItem] = []) {
        self.title = title
        self.items = items
    }
}

/// A set of methods that your delegate object must implement to interact with
/// the segmented collection view.
///
/// A default implementation of the function considered optional exists for objects inheriting from `NSObject`.
public protocol SegmentedCollectionViewDelegate: AnyObject {
    // MARK: - Managing Selections

    /// Tells the delegate that the specified item is now selected.
    ///
    /// - Parameters:
    ///   - collectionView: A `SegmentedCollectionView` object informing the delegate about the new item selection.
    ///   - item: The new selected item.
    func segmentedCollectionView(_ collectionView: SegmentedCollectionView,
                                 didSelectItem item: FlaneurCollectionItem)

    /// Tells the delegate that the segmented collection view is about to draw its header view.
    ///
    /// - Parameters:
    ///   - collectionView: A `SegmentedCollectionView` object informing the delegate of this impending event.
    ///   - header: The header about to be drawn.
    func segmentedCollectionView(_ collectionView: SegmentedCollectionView,
                                 willDisplayHeader header: UIView)

    // MARK: - Configuring the UI Style

    /// Asks the delegate for the height to use for the header view.
    ///
    /// - Parameter collectionView: The `SegmentedCollectionView` object requesting this information.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) that the header view should be.
    func heightOfHeaderView(in collectionView: SegmentedCollectionView) -> CGFloat

    /// Asks the delegate for the size of the vertical padding to use for items.
    ///
    /// - Parameter collectionView: The `SegmentedCollectionView` object requesting this information.
    /// - Returns: A nonnegative floating-point value that specifies the dimension (in points) that the vertical padding of the collection view should be.
    func verticalPaddingForItems(in collectionView: SegmentedCollectionView) -> CGFloat

    /// Asks the delegate how many columns should be displayed for one of the section of the view.
    ///
    /// - Parameters:
    ///   - collectionView: The `SegmentedCollectionView` object requesting this information.
    ///   - section: An index number identifying a section of the collectionView.
    /// - Returns: The number of columns in section.
    func segmentedCollectionView(_ collectionView: SegmentedCollectionView,
                                 numberOfColumnsForSection section: Int) -> Int

    /// Asks the delegate for the height to use for a row in a specified location.
    ///
    /// - Parameters:
    ///   - collectionView: The `SegmentedCollectionView` object requesting this information.
    ///   - width: The width that will be used for the cell.
    ///   - section: An index number identifying a section of the collectionView.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) that the item's cell should be.
    func segmentedCollectionView(_ collectionView: SegmentedCollectionView,
                                 heightForItemWithWidth width: CGFloat,
                                 forSection section: Int) -> CGFloat
}

public extension SegmentedCollectionViewDelegate where Self: NSObject {
    func segmentedCollectionView(_ collectionView: SegmentedCollectionView,
                                 willDisplayHeader header: UIView) {
        () // Do nothing by default
    }

    func heightOfHeaderView(in collectionView: SegmentedCollectionView) -> CGFloat {
        return defaultHeaderViewHeight
    }

    func segmentedCollectionView(_ collectionView: SegmentedCollectionView,
                                 numberOfColumnsForSection section: Int) -> Int {
        return defaultNumberOfColumns
    }

    func segmentedCollectionView(_ collectionView: SegmentedCollectionView,
                                 heightForItemWithWidth width: CGFloat,
                                 forSection section: Int) -> CGFloat {
        return width
    }

    func verticalPaddingForItems(in collectionView: SegmentedCollectionView) -> CGFloat {
        return defaultVerticalPaddingForItems
    }
}

/// An object that manages a segmented collection of data items and presents them using a collection view.
///
/// It looks like this:
///
/// TODO
final public class SegmentedCollectionView: UIView {
    // MARK: - Properties

    /// The header of the view.
    public var headerView: UIView = UIView(frame: .zero) {
        didSet {
            self.collectionView.reloadData()
        }
    }

    /// The sections to present in the view
    public var itemsSections: [SegmentedCollectionSection] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    /// The object that acts as the delegate of the segmented collection view.
    public weak var delegate: SegmentedCollectionViewDelegate? = nil {
        didSet {
            // Update delegate dependent configuration of the view layout
            collectionViewLayout.minimumLineSpacing = gutterHeight
        }
    }

    fileprivate var registeredClassesNames: [String] = []
    fileprivate var registeredNibNames: [String] = []
    private(set) var collectionView: UICollectionView!
    private var collectionViewLayout: UICollectionViewFlowLayout!

    var selectedItemsSectionIndex: Int = 0
    var selectedItems: [FlaneurCollectionItem] {
        return itemsSections[selectedItemsSectionIndex].items
    }

    // MARK: - Lifecycle

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didLoad()
    }

    var gutterHeight: CGFloat {
        return delegate?.verticalPaddingForItems(in: self) ?? defaultVerticalPaddingForItems
    }

    func didLoad() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionHeadersPinToVisibleBounds = true // We want the segment control to always be visible
        collectionViewLayout.minimumLineSpacing = gutterHeight
        collectionViewLayout.minimumInteritemSpacing = gutterWidth

        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsetsMake(0.0, gutterWidth, 0.0, gutterWidth)

        collectionView.register(ContainerCollectionViewCell.self,
                                forCellWithReuseIdentifier: "SegmentedCollectionViewHeader")
        collectionView.register(SegmentedControlHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: "SegmentedControlHeaderCollectionReusableView")

        self.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        _ = LayoutBorderManager.init(item: collectionView,
                                     toItem: self,
                                     top: 0.0,
                                     left: 0.0,
                                     bottom: 0.0,
                                     right: 0.0)

        self.backgroundColor = .lightGray
        collectionView.backgroundColor = .white
    }
}

extension SegmentedCollectionView: UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            delegate?.segmentedCollectionView(self, didSelectItem: selectedItems[indexPath.row])
        }
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath == IndexPath(row: 0, section: 0) else { return }
        guard let containerCell = cell as? ContainerCollectionViewCell else { return }
        guard let containedView = containerCell.containedView else { return }
        delegate?.segmentedCollectionView(self, willDisplayHeader: containedView)
    }
}

extension SegmentedCollectionView: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemsSections.isEmpty ? 1 : 2 // 1 for the header + 1 for the actual collection
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: // The header
            return 1
        case 1: // The collection
            return selectedItems.count
        default:
            fatalError("unexpected section \(section)")
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return cellForHeaderWithView(headerView, indexPath: indexPath)
        case 1:
            return cellForCollectionPartAtIndexPath(indexPath)
        default:
            fatalError("unexpected indexPath \(indexPath)")
        }
    }

    func cellForHeaderWithView(_ view: UIView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentedCollectionViewHeader", for: indexPath) as! ContainerCollectionViewCell
        cell.configureWithView(containedView: view)
        return cell
    }

    func cellForCollectionPartAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let item = selectedItems[indexPath.row]
        var cell: UICollectionViewCell? = nil

        switch item.cellStyle {
        case .cellClass(let cellClass):
            let identifier = String(describing: cellClass)
            if !registeredClassesNames.contains(identifier) {
                registeredClassesNames.append(identifier)
                collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
            }
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath)
        case .nibName(let nibName):
            if !registeredNibNames.contains(nibName) {
                registeredNibNames.append(nibName)
                let nib = UINib(nibName: nibName, bundle: nil)
                collectionView.register(nib, forCellWithReuseIdentifier: nibName)
            }
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: nibName,
                                                      for: indexPath)
        }

        guard cell != nil else { fatalError("cell is still nil") }
        item.configureCell(cell: cell!)
        return cell!
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "SegmentedControlHeaderCollectionReusableView",
                                                                         for: indexPath) as? SegmentedControlHeaderCollectionReusableView

            let headerItems = itemsSections.map { segmentedCollectionSection in
                return SegmentedCollectionItemControl(title: "\(segmentedCollectionSection.items.count)\n\(segmentedCollectionSection.title)")
            }
            header?.configure(items: headerItems, selectedIndex: selectedItemsSectionIndex)
            header?.delegate = self

            return header!
        default:
            fatalError("viewForSupplementaryElementOfKind unexpectedly requested for \(indexPath)")
        }
    }
}

extension SegmentedCollectionView: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            //the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values.
            let width = self.frame.width - 2 * gutterWidth
            let height = self.delegate?.heightOfHeaderView(in: self) ?? defaultHeaderViewHeight
            return CGSize(width: width, height: height)
        case 1:

            let nbColumns = self.delegate?.segmentedCollectionView(self, numberOfColumnsForSection: selectedItemsSectionIndex) ?? defaultNumberOfColumns

            guard nbColumns > 0 else {
                fatalError("SegmentedCollectionView does not support 0 column.")
            }

            let width: CGFloat = floor((self.frame.width - CGFloat(nbColumns + 1) * gutterWidth) / CGFloat(nbColumns))
            let height = self.delegate?.segmentedCollectionView(self, heightForItemWithWidth: width, forSection: selectedItemsSectionIndex) ?? width
            return CGSize(width: width,
                          height: height)
        default:
            fatalError("unexpected section \(indexPath.section)")
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: self.frame.width,
                          height: segmentControlHeight)
        } else {
            return .zero
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: gutterHeight,
                                left: 0.0,
                                bottom: gutterHeight,
                                right: 0.0)
        } else {
            return .zero
        }
    }
}

extension SegmentedCollectionView: SegmentedControlHeaderDelegate {
    func segmentedControlHeaderDidSelectItemAt(_ index: Int) {
        selectedItemsSectionIndex = index
        collectionView.reloadData()
    }
}
