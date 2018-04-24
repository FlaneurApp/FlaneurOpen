import Foundation
import IGListKit

/// An enumeration of the types supported by `FlaneurFormView`.
public enum FlaneurFormElementType {
    // MARK: - Supported types

    /// The type of text field elements (ie 1-line).
    case textField

    /// The type of text area elements (ie multi-line).
    case textArea

    /// The type of image picker elements.
    case imagePicker(delegate: FlaneurFormImagePickerElementCollectionViewCellDelegate)

    /// The type of the main select element of a form.
    case select(delegate: FlaneurFormSelectElementCollectionViewCellDelegate)

    /// The type of the seconday select element of a form.
    /// (duplicated for bad design reasons and reusability of form components, cf. `FlaneurFormView` documentation for more information about why the design is bad).
    case selectBis(delegate: FlaneurFormSelectElementCollectionViewCellDelegate)

    /// The type of a deletion element.
    case delete(delegate: FlaneurFormDeleteElementCollectionViewCellDelegate)

    /// The type of a button element.
    case button
}

extension FlaneurFormElementType: Equatable {
    // MARK: - Equatable Protocol

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

/// A basic element of a `FlaneurFormView`.
///
/// - SeeAlso: FlaneurFormView
public class FlaneurFormElement {
    let type: FlaneurFormElementType
    let label: String
    let didLoadHandler: ((UIView) -> ())?

    // MARK: - Creating a new form element

    /// Initializes a new instance of a form element of the given type.
    ///
    /// - Parameters:
    ///   - type: the type of the form element.
    ///   - label: the label of the form element.
    ///   - didLoadHandler: the callback that gets called, after the form element did load, with the attached view
    ///
    /// - SeeAlso: FlaneurFormElementType
    public init(type: FlaneurFormElementType, label: String, didLoadHandler: ((UIView) -> ())? = nil) {
        self.type = type
        self.label = label
        self.didLoadHandler = didLoadHandler
    }
}

extension FlaneurFormElement: Equatable {
    // MARK: - Equatable Protocol

    public static func == (lhs: FlaneurFormElement, rhs: FlaneurFormElement) -> Bool {
        return
            lhs.type == rhs.type
                && lhs.label == rhs.label
    }
}

extension FlaneurFormElement: ListDiffable {
    // MARK: - ListDiffable protocol

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
