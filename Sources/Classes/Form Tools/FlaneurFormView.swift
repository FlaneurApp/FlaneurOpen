import UIKit
import IGListKit
import FlaneurImagePicker

/// View in charge of displaying form elements.
///
/// It is quite poorly designed as many problems arose late in the implementation:
///
/// 1. Instead of a form, it would probably make more sense to use a table view controller
/// 1. Using a `IGListKit`-backed collection view is a terrible idea, it should be
///    a simple table view
/// 1. Since we design a form, we should skip reusable cells and just keep stong references
///    of every cell: we wouldn't need a cache anymore
///
/// objc.io's Swit Talks addressed the problems of reusable form components design in a
/// series. It is a good inspiration to redesign this component.
///
/// Also, `FlaneurImagePicker` is actually a form component library. It would probably make
/// sense that other form components belong to the same library, that should then be renamed
/// `FlaneurForm` or something similar.
public final class FlaneurFormView: UIView {
    // MARK: - Internal Attributes
    var listAdapter: ListAdapter!
    weak var viewController: UIViewController?
    fileprivate var textCache: [String: String?] = [:]
    var respondingCell: UICollectionViewCell? = nil

    // MARK: - Subviews

    // The collection view of form elements.
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

    // MARK: - View Lifecycle

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

    /// Calls this exactly once.
    ///
    /// - Parameter viewController: the view controller presenting the form.
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

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }

    /// Adds a form element.
    ///
    /// - Parameters:
    ///   - formElement: the form element to add to the form.
    ///   - cacheValue: the cache value in case the form element is textual (this is terrible design).
    ///
    /// - SeeAlso: FlaneurFormElement
    public func addFormElement(_ formElement: FlaneurFormElement, cacheValue: String? = nil) {
        formElements.append(formElement)
        textCache[formElement.label] = cacheValue
    }

    // MARK: - Private stuff

    func didLoad() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension FlaneurFormView: ListAdapterDataSource {
    // MARK: - ListAdapterDataSource Protocol

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
    // MARK: - ListDisplayDelegate

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
    public func nextElementShouldBecomeFirstResponder(cell: FlaneurFormElementCollectionViewCell) {
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

    public func scrollToVisibleSection(cell: FlaneurFormElementCollectionViewCell) {
        respondingCell = cell

        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        guard let layoutAttributes = self.collectionView.layoutAttributesForItem(at: indexPath) else { return }
        collectionView.scrollRectToVisible(layoutAttributes.frame, animated: true)
    }

    public func presentViewController(viewController: UIViewController) {
        self.viewController?.present(viewController, animated: true)
    }

    public func cacheValue(forLabel label: String) -> String? {
        if let cacheValue = self.textCache[label] {
            return cacheValue
        } else {
            return nil
        }
    }
}
