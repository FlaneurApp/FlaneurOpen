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

    func localizedStringForTitle() -> String
    func localizedStringForCancelAction() -> String
    func localizedStringForDoneAction() -> String
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

    func localizedStringForTitle() -> String {
        return "Pick your pictures"
    }

    func localizedStringForCancelAction() -> String {
        return "Cancel"
    }

    func localizedStringForDoneAction() -> String {
        return "Done"
    }
}

class FlaneurFormImagePickerElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    var imageDelegate: FlaneurFormImagePickerElementCollectionViewCellDelegate?
    var launcherButton: UIButton!
    var photosCollectionView: UICollectionView!

    var currentSelection: [FlaneurImageDescription] = [] {
        didSet {
            photosCollectionView.reloadData()
        }
    }

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

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        self.photosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.backgroundColor = .white
        photosCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 15.0)
        layout.minimumLineSpacing = 9.0 // Spacing between items

        photosCollectionView.register(PhotoCollectionViewCell.self,
                                      forCellWithReuseIdentifier: "PhotoCollectionViewCell")

        self.addSubview(launcherButton)
        self.addSubview(photosCollectionView)

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

        _ = LayoutBorderManager(item: photosCollectionView,
                                toItem: self,
                                bottom: 16.0,
                                right: 0.0)
        NSLayoutConstraint(item: photosCollectionView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 80.0).isActive = true

        NSLayoutConstraint(item: photosCollectionView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: launcherButton,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 8.0).isActive = true
    }

    override func configureWith(formElement: FlaneurFormElement) {
        super.configureWith(formElement: formElement)

        if case FlaneurFormElementType.imagePicker(let cellDelegate) = formElement.type {
            self.imageDelegate = cellDelegate
            self.currentSelection = imageDelegate!.initialSelection()

            launcherButton.setImage(imageDelegate!.buttonImage().withRenderingMode(.alwaysTemplate),
                                    for: .normal)
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
                                                         selectedImages: currentSelection)
        flaneurPicker.config.cancelButtonTitle = imageDelegate!.localizedStringForCancelAction()
        flaneurPicker.config.doneButtonTitle = imageDelegate!.localizedStringForDoneAction()
        flaneurPicker.config.navBarTitle = imageDelegate!.localizedStringForTitle()

        flaneurPicker.config.navBarBackgroundColor = .white
        flaneurPicker.config.navBarTitleColor = .black

        flaneurPicker.config.backgroundColorForSection = [
            .pickerView: UIColor(white: (236.0 / 255.0), alpha: 1.0),
            .imageSources: .white,
            .selectedImages: UIColor(white: (236.0 / 255.0), alpha: 1.0)
        ]

        flaneurPicker.delegate = self

        delegate?.presentViewController(viewController: flaneurPicker)
    }
}

extension FlaneurFormImagePickerElementCollectionViewCell: FlaneurImagePickerControllerDelegate {
    func didPickImages(images: [FlaneurImageDescription], userInfo: Any?) {
        self.currentSelection = images
        imageDelegate?.didPickImages(images: images, userInfo: userInfo)
    }

    func didCancelPickingImages() {
        imageDelegate?.didCancelPickingImages()
    }
}

extension FlaneurFormImagePickerElementCollectionViewCell: UICollectionViewDelegate {

}

extension FlaneurFormImagePickerElementCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentSelection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.configureWith(imageDescription: currentSelection[indexPath.row])
        return cell
    }
}

extension FlaneurFormImagePickerElementCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 80.0)
    }
}
