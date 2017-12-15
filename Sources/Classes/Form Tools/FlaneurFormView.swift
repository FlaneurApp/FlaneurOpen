//
//  FlaneurFormView.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit
import IGListKit
import FlaneurImagePicker

public enum FlaneurFormElementType {
    case textField
    case textArea
    case imagePicker(delegate: FlaneurFormImagePickerElementCollectionViewCellDelegate)
    case select(delegate: FlaneurFormSelectElementCollectionViewCellDelegate)
    case selectBis(delegate: FlaneurFormSelectElementCollectionViewCellDelegate)
    case delete(delegate: FlaneurFormDeleteElementCollectionViewCellDelegate)
    case button
}

extension FlaneurFormElementType: Equatable {
    public static func == (lhs: FlaneurFormElementType, rhs: FlaneurFormElementType) -> Bool {
        switch (lhs, rhs) {
        case (.imagePicker(_), .imagePicker(_)):
            return true
        case (.textArea, .textArea):
            return true
        case (.textField, .textField):
            return true
        case (.select, .select):
            return true
        case (.selectBis, .selectBis):
            return true
        case (.delete, .delete):
            return true
        case (.button, .button):
            return true
        default:
            return false
        }
    }
}

public class FlaneurFormElement {
    let type: FlaneurFormElementType
    let label: String
    let didLoadHandler: ((UIView) -> ())?

    public init(type: FlaneurFormElementType, label: String, didLoadHandler: ((UIView) -> ())? = nil) {
        self.type = type
        self.label = label
        self.didLoadHandler = didLoadHandler
    }
}

extension FlaneurFormElement: Equatable {
    public static func == (lhs: FlaneurFormElement, rhs: FlaneurFormElement) -> Bool {
        return
            lhs.type == rhs.type
                && lhs.label == rhs.label
    }
}

extension FlaneurFormElement: ListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: label)
    }

    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let otherFormElement = object as? FlaneurFormElement {
            return self == otherFormElement
        } else {
            return false
        }
    }
}

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

class FlaneurFormElementSectionController: ListSectionController {
    let formElement: FlaneurFormElement
    weak var cellDelegate: FlaneurFormElementCollectionViewCellDelegate?

    init(formElement: FlaneurFormElement,
         cellDelegate: FlaneurFormElementCollectionViewCellDelegate?,
         displayDelegate: ListDisplayDelegate) {
        self.formElement = formElement
        self.cellDelegate = cellDelegate
        super.init()
        self.displayDelegate = displayDelegate
    }

    override func sizeForItem(at index: Int) -> CGSize {
        var height: CGFloat = 44.0

        switch formElement.type {
        case .textField:
            height = 72.0
        case .textArea:
            height = 160.0
        case .imagePicker:
            height = 136.0
        case .select(let delegate):
            height = delegate.selectCollectionViewSize().height + 44.0 + 16.0
        case .selectBis(let delegate):
            height = delegate.selectCollectionViewSize().height + 44.0 + 16.0
        case .delete:
            height = 56.0
        case .button:
            height = 194.0
        }

        return CGSize(width: self.collectionContext!.containerSize.width,
                      height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        switch formElement.type {
        case .textField:
            let cell = collectionContext?.dequeueReusableCell(of: FlaneurFormTextFieldElementCollectionViewCell.self,
                                                              for: self,
                                                              at: index) as? FlaneurFormTextFieldElementCollectionViewCell
            cell?.configureWith(formElement: formElement)
            cell?.textField.text = cellDelegate?.cacheValue(forLabel: formElement.label)
            cell?.delegate = cellDelegate
            return cell!
        case .textArea:
            let cell = collectionContext?.dequeueReusableCell(of: FlaneurFormTextAreaElementCollectionViewCell.self,
                                                              for: self,
                                                              at: index) as? FlaneurFormTextAreaElementCollectionViewCell
            cell?.configureWith(formElement: formElement)
            cell?.textArea.text = cellDelegate?.cacheValue(forLabel: formElement.label) ?? ""
            cell?.delegate = cellDelegate
            return cell!
        case .imagePicker:
            let cell = collectionContext?.dequeueReusableCell(of: FlaneurFormImagePickerElementCollectionViewCell.self,
                                                              for: self,
                                                              at: index) as? FlaneurFormImagePickerElementCollectionViewCell
            cell?.configureWith(formElement: formElement)
            cell?.delegate = cellDelegate
            return cell!
        case .select(let selectDelegate):
            let cell = collectionContext?.dequeueReusableCell(of: FlaneurFormSelectElementCollectionViewCell.self,
                                                              for: self,
                                                              at: index) as? FlaneurFormSelectElementCollectionViewCell
            cell?.delegate = cellDelegate
            cell?.selectDelegate = selectDelegate
            cell?.configureWith(formElement: formElement)
            return cell!
        case .selectBis(let selectDelegate):
            let cell = collectionContext?.dequeueReusableCell(of: FlaneurFormSelectBisElementCollectionViewCell.self,
                                                              for: self,
                                                              at: index) as? FlaneurFormSelectBisElementCollectionViewCell
            cell?.delegate = cellDelegate
            cell?.selectDelegate = selectDelegate
            cell?.configureWith(formElement: formElement)
            return cell!
        case .delete(let tapDelegate):
            let cell = collectionContext?.dequeueReusableCell(of: FlaneurFormDeleteElementCollectionViewCell.self,
                                                              for: self,
                                                              at: index) as? FlaneurFormDeleteElementCollectionViewCell
            cell?.delegate = cellDelegate
            cell?.tapDelegate = tapDelegate
            cell?.configureWith(formElement: formElement)
            return cell!
        case .button:
            let cell = collectionContext?.dequeueReusableCell(of: FlaneurFormButtonCollectionViewCell.self,
                                                              for: self,
                                                              at: index) as? FlaneurFormButtonCollectionViewCell
            cell?.delegate = cellDelegate
            // cell?.tapDelegate = tapDelegate
            cell?.configureWith(formElement: formElement)
            return cell!
        }
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
