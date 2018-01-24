//
//  FlaneurFormElement.swift
//  ActionKit
//
//  Created by Mickaël Floc'hlay on 24/01/2018.
//

import Foundation
import IGListKit

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

