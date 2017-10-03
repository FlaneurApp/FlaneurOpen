//
//  FlaneurFormImagePickerElementCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//

import UIKit
import FlaneurImagePicker

public protocol FlaneurFormImagePickerElementCollectionViewCellDelegate: FlaneurImagePickerControllerDelegate {
    func buttonImage() -> UIImage
    func numberOfImages() -> Int
    func initialSelection() -> [FlaneurImageDescription]
    func sourceDelegates() -> [FlaneurImageSource]
}

public extension FlaneurFormImagePickerElementCollectionViewCellDelegate where Self: UIViewController {
    func numberOfImages() -> Int {
        return 1
    }

    func initialSelection() -> [FlaneurImageDescription] {
        return []
    }

    func sourceDelegates() -> [FlaneurImageSource] {
        return []
    }
}

class FlaneurFormImagePickerElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    var imageDelegate: FlaneurFormImagePickerElementCollectionViewCellDelegate?
    var launcherButton: UIButton!

    /// Common init code.
    override func didLoad() {
        super.didLoad()

        let launcherButton = UIButton()
        launcherButton.backgroundColor = UIColor(white: (39.0 / 255.0), alpha: 1.0)
        self.launcherButton = launcherButton
        launcherButton.translatesAutoresizingMaskIntoConstraints = false
        launcherButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        launcherButton.tintColor = .white
        launcherButton.contentMode = .scaleAspectFill

        self.addSubview(launcherButton)

        _ = LayoutBorderManager(item: launcherButton,
                                toItem: self,
                                left: 16.0,
                                bottom: 16.0)

        NSLayoutConstraint(item: launcherButton,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: label,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 4.0).isActive = true
        NSLayoutConstraint(item: launcherButton,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 80.0).isActive = true
        NSLayoutConstraint(item: launcherButton,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 80.0).isActive = true
    }

    override func configureWith(formElement: FlaneurFormElement) {
        super.configureWith(formElement: formElement)

        if case FlaneurFormElementType.imagePicker(let cellDelegate) = formElement.type {
            self.imageDelegate = cellDelegate

            launcherButton.setImage(imageDelegate!.buttonImage().withRenderingMode(.alwaysTemplate),
                                    for: .normal)

            if let firstImage = imageDelegate?.initialSelection().first {
                launcherButton.setBackgroundImage(firstImage.image, for: .normal)
            }
        }

        formElement.didLoadHandler?(launcherButton)
    }

    override func becomeFirstResponder() -> Bool {
        delegate?.scrollToVisibleSection(cell: self)
        launcherButton.isSelected = true
        return true
    }

    func buttonPressed(_ sender: Any? = nil) {
        _ = self.becomeFirstResponder()

        let flaneurPicker = FlaneurImagePickerController(maxNumberOfSelectedImages: imageDelegate!.numberOfImages(),
                                                         userInfo: nil,
                                                         sourcesDelegate: imageDelegate!.sourceDelegates(),
                                                         selectedImages: imageDelegate!.initialSelection())
        flaneurPicker.config.cancelButtonTitle = "TODO"
        flaneurPicker.config.doneButtonTitle = "TODO"
        flaneurPicker.config.navBarTitle = "TODO"

//        // flaneurPicker.config.removeButtonColor = .red
//
//        flaneurPicker.config.backgroundColorForSection = [
//            .pickerView: UIColor(red: 36/255, green: 41/255, blue: 50/255, alpha: 1),
//            .imageSources: UIColor(red: 36/255, green: 41/255, blue: 50/255, alpha: 1),
//            .selectedImages: UIColor(red: 36/255, green: 41/255, blue: 50/255, alpha: 1),
//        ]
//
//        //        flaneurPicker.config.authorizationViewCustomClass = TestView.self
//
//        flaneurPicker.config.paddingForImagesPickerView = UIEdgeInsets (top: 3, left: 3, bottom: 3, right: 3)
//        //        flaneurPicker.config.sizeForImagesPickerView = CGSize(width: 100, height: 100)
//
//        //        flaneurPicker.config.imageSourcesBackgroundColor = [.instagram: .brown]
//        //        flaneurPicker.config.imageSourcesCellWidth = 200
//
//
//        //        flaneurPicker.config.sectionsOrderArray = [.imageSources, .pickerView, .selectedImages]

        flaneurPicker.delegate = self

        delegate?.presentViewController(viewController: flaneurPicker)
    }
}

extension FlaneurFormImagePickerElementCollectionViewCell: FlaneurImagePickerControllerDelegate {
    func didPickImages(images: [FlaneurImageDescription], userInfo: Any?) {
        if let firstImage = images.first {
            switch firstImage.imageSource {
            case .urlBased:
                debugPrint("Load image")
            case .imageBased, .phassetBased:
                launcherButton.setBackgroundImage(firstImage.image, for: .normal)
            default:
                debugPrint("...")
            }
        }

        imageDelegate?.didPickImages(images: images, userInfo: userInfo)

//        for image in images {
//            if image.imageSource == .urlBased {
//                // Use the url property
//                // Do something with => image.imageURL
//                print(image.imageURL)
//            } else { // .imageBased or .phassetBased
//                // Use the image property
//                // Do something with => image.image
//                print(image.image)
//            }
//        }
    }

    func didCancelPickingImages() {
        imageDelegate?.didCancelPickingImages()
    }
}
