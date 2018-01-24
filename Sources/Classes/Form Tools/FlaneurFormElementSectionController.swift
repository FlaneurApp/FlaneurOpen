//
//  FlaneurFormElementSectionController.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 24/01/2018.
//

import Foundation
import IGListKit

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
