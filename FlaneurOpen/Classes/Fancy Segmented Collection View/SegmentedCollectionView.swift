//
//  SegmentedCollectionView.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 11/10/2017.
//

import UIKit
import IGListKit

fileprivate let gutterWidth: CGFloat = 9.0
fileprivate let nbColumns: Int = 2
fileprivate let collapsedHeaderViewHeight: CGFloat = 26.0
fileprivate let expendedHeaderViewHeight: CGFloat = 306.0
fileprivate let segmentControlHeight: CGFloat = 65.0

public struct SegmentedCollectionSection {
    let title: String
    let items: [FlaneurCollectionItem]

    public init(title: String, items: [FlaneurCollectionItem] = []) {
        self.title = title
        self.items = items
    }
}

public protocol SegmentedCollectionViewDelegate {
    func segmentedCollectionView(_ collectionView: SegmentedCollectionView, didSelectItem item: FlaneurCollectionItem)
}

final public class SegmentedCollectionView: UIView {
    public var headerView: UIView = UIView(frame: .zero) {
        didSet {
            self.collectionView.reloadData()
        }
    }

    public var itemsSections: [SegmentedCollectionSection] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    fileprivate var registeredClassesNames: [String] = []
    fileprivate var registeredNibNames: [String] = []
    private(set) var collectionView: UICollectionView!

    var selectedItemsSectionIndex: Int = 0
    var selectedItems: [FlaneurCollectionItem] {
        return itemsSections[selectedItemsSectionIndex].items
    }

    public var delegate: SegmentedCollectionViewDelegate? = nil

    public override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didLoad()
    }

    func didLoad() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true // We want the segment control to always be visible
        layout.minimumLineSpacing = gutterWidth
        layout.minimumInteritemSpacing = gutterWidth

        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
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

    public func configure() {
        print("didLoad — view.width: \(self.frame.width)")
    }
}

extension SegmentedCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            delegate?.segmentedCollectionView(self, didSelectItem: selectedItems[indexPath.row])
        }
    }
}

extension SegmentedCollectionView: UICollectionViewDataSource {
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
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            //the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values.
            let width = self.frame.width - 2 * gutterWidth
            return CGSize(width: width,
                          height: expendedHeaderViewHeight)
        case 1:
            let squareSize: CGFloat = floor((self.frame.width - CGFloat(nbColumns + 1) * gutterWidth) / CGFloat(nbColumns))
            return CGSize(width: squareSize,
                          height: squareSize)
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
            return UIEdgeInsets(top: gutterWidth,
                                left: 0.0,
                                bottom: gutterWidth,
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