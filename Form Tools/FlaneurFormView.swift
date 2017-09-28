//
//  FlaneurFormView.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit
import IGListKit

public enum FlaneurFormElementType {
    case textField
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

    // The collection view of form elements
    let collectionView: UICollectionView = {
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
        listAdapter = {
            return ListAdapter(updater: ListAdapterUpdater(),
                               viewController: viewController,
                               workingRangeSize: 1)
        }()

        // Finish setting up things
        listAdapter.collectionView = collectionView
        listAdapter.dataSource = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .darkGray
        self.addSubview(collectionView)

        _ = LayoutBorderManager(item: collectionView,
                            toItem: self,
                            top: 0.0,
                            left: 0.0,
                            bottom: 0.0,
                            right: 0.0)
    }

    public func addFormElement(_ formElement: FlaneurFormElement) {
        formElements.append(formElement)
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
            return FlaneurFormElementSectionController(formElement: formElement)
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

    init(formElement: FlaneurFormElement) {
        self.formElement = formElement
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: self.collectionContext!.containerSize.width,
                      height: 72.0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if let cell = collectionContext?.dequeueReusableCell(of: FlaneurFormTextFieldElementCollectionViewCell.self,
                                                             for: self,
                                                             at: index) as? FlaneurFormTextFieldElementCollectionViewCell {
            cell.configureWith(formElement: formElement)
            return cell
        } else {
            fatalError("unhandled case")
        }
    }
}
