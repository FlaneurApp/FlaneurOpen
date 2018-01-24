//
//  FlaneurFormView.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit
import IGListKit
import FlaneurImagePicker

public final class FlaneurFormView: UIView {
    var listAdapter: ListAdapter!
    weak var viewController: UIViewController?
    fileprivate var textCache: [String: String?] = [:]
    var respondingCell: UICollectionViewCell? = nil

    // The collection view of form elements
    public let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical

        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = true
        return view
    }()

    var formElements: [FlaneurFormElement] = [] {
        didSet {
            listAdapter.performUpdates(animated: true)
        }
    }

    /// Initializes and returns a newly allocated navigation bar object with the specified frame rectangle.
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

    // MARK: - Public API

    public func configure(viewController: UIViewController) {
        self.viewController = viewController

        listAdapter = {
            return ListAdapter(updater: ListAdapterUpdater(),
                               viewController: viewController,
                               workingRangeSize: 1)
        }()

        // Finish setting up things
        listAdapter.collectionView = collectionView
        listAdapter.dataSource = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        self.addSubview(collectionView)

        _ = LayoutBorderManager(item: collectionView,
                                toItem: self,
                                top: 0.0,
                                left: 0.0,
                                bottom: 0.0,
                                right: 0.0)
    }

    public func addFormElement(_ formElement: FlaneurFormElement,
                               cacheValue: String? = nil) {
        formElements.append(formElement)
        textCache[formElement.label] = cacheValue
    }

    // MARK: - Private stuff

    func didLoad() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension FlaneurFormView: ListAdapterDataSource {
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return formElements
    }

    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let formElement = object as? FlaneurFormElement {
            return FlaneurFormElementSectionController(formElement: formElement,
                                                       cellDelegate: self,
                                                       displayDelegate: self)
        } else {
            fatalError("unhandled case")
        }
    }

    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }
}

extension FlaneurFormView: ListDisplayDelegate {
    public func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
    }

    public func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
    }

    public func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
    }

    public func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        if let mySectionController = sectionController as? FlaneurFormElementSectionController {
            switch mySectionController.formElement.type {
            case .textField:
                if let myCell = cell as? FlaneurFormTextFieldElementCollectionViewCell {
                    let label = mySectionController.formElement.label
                    let value = myCell.textField.text
                    self.textCache[label] = value
                }

            case .textArea:
                if let myCell = cell as? FlaneurFormTextAreaElementCollectionViewCell {
                    let label = mySectionController.formElement.label
                    let value = myCell.textArea.text
                    self.textCache[label] = value
                }

            default:
                debugPrint("No cache management for type \(mySectionController.formElement.type)")
            }
        }
    }

    public func scrollCurrentFieldToVisible() {
        guard let currentCell = self.respondingCell as? FlaneurFormElementCollectionViewCell else { return }
        scrollToVisibleSection(cell: currentCell)
    }
}

extension FlaneurFormView: FlaneurFormElementCollectionViewCellDelegate {
    func nextElementShouldBecomeFirstResponder(cell: FlaneurFormElementCollectionViewCell) {
        if let thisIndex = self.collectionView.indexPath(for: cell) {
            let nextSection = (thisIndex.section + 1) % formElements.count
            let nextIndexPath = IndexPath(row: 0, section: nextSection)
            if let nextCell = self.collectionView.cellForItem(at: nextIndexPath) {
                nextCell.becomeFirstResponder()
            } else {
                debugPrint("DEBUG: couldn't find cell at \(nextIndexPath)")
            }
        }
    }

    func scrollToVisibleSection(cell: FlaneurFormElementCollectionViewCell) {
        respondingCell = cell

        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        guard let layoutAttributes = self.collectionView.layoutAttributesForItem(at: indexPath) else { return }
        collectionView.scrollRectToVisible(layoutAttributes.frame, animated: true)
    }

    func presentViewController(viewController: UIViewController) {
        self.viewController?.present(viewController, animated: true)
    }

    func cacheValue(forLabel label: String) -> String? {
        if let cacheValue = self.textCache[label] {
            return cacheValue
        } else {
            return nil
        }
    }
}
