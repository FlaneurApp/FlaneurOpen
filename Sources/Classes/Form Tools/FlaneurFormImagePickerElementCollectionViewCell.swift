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
    func initialSelection() -> [FlaneurImageDescriptor]
    func sourceProviders() -> [FlaneurImageProvider]

    func localizedAttributedStringForTitle() -> NSAttributedString
    func localizedStringForCancelAction() -> String
    func localizedStringForDoneAction() -> String
}

public extension FlaneurFormImagePickerElementCollectionViewCellDelegate where Self: UIViewController {
    func numberOfImages() -> Int {
        return 1
    }

    func initialSelection() -> [FlaneurImageDescriptor] {
        return []
    }

    func sourceProviders() -> [FlaneurImageProvider] {
        return FlaneurImagePickerConfig.defaultSources
    }

    func localizedAttributedStringForTitle() -> NSAttributedString {
        return NSAttributedString(string: "Pick your pictures")
    }

    func localizedStringForCancelAction() -> String {
        return "Cancel"
    }

    func localizedStringForDoneAction() -> String {
        return "Done"
    }
}

final class FlaneurFormImagePickerElementCollectionViewCell: FlaneurFormElementCollectionViewCell {
    weak var imageDelegate: FlaneurFormImagePickerElementCollectionViewCellDelegate?
    let launcherButton: UIButton = UIButton()
    let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 9.0 // Spacing between items

        let result = UICollectionView(frame: .zero, collectionViewLayout: layout)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.backgroundColor = .white
        result.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 15.0)
        return result
    }()

    var currentSelection: [FlaneurImageDescriptor] = [] {
        didSet {
            photosCollectionView.reloadData()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self

        launcherButton.backgroundColor = UIColor(white: (39.0 / 255.0), alpha: 1.0)
        launcherButton.translatesAutoresizingMaskIntoConstraints = false
        launcherButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        launcherButton.tintColor = .white
        launcherButton.contentMode = .scaleAspectFill

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

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    @objc func buttonPressed(_ sender: Any? = nil) {
        _ = self.becomeFirstResponder()

        let flaneurPicker = FlaneurImagePickerController(userInfo: nil,
                                                         imageProviders: imageDelegate!.sourceProviders(),
                                                         selectedImages: currentSelection)

        // Picker Configuration
        flaneurPicker.view.backgroundColor = .white
        flaneurPicker.navigationBar.tintColor = .black
        flaneurPicker.navigationBar.barTintColor = .white
        flaneurPicker.navigationBar.isTranslucent = false
        flaneurPicker.navigationBar.topItem?.leftBarButtonItem?.title = imageDelegate!.localizedStringForCancelAction()
        flaneurPicker.navigationBar.topItem?.rightBarButtonItem?.title = imageDelegate!.localizedStringForDoneAction()

        let myTitleViewContainer = FullWidthNavigationItemTitle(frame: CGRect(x: 0.0, y: 0.0, width: 1000.0, height: 0.0))
        myTitleViewContainer.containingView = flaneurPicker.navigationBar
        let myTitleText = UILabel(frame: .zero)
        myTitleText.numberOfLines = 1
        myTitleText.attributedText = imageDelegate!.localizedAttributedStringForTitle()
        myTitleText.font = FlaneurOpenThemeManager.shared.theme.navigationBarTitleFont
        myTitleViewContainer.titleLabel = myTitleText
        flaneurPicker.navigationBar.topItem?.titleView = myTitleViewContainer

        flaneurPicker.config.backgroundColorForSection = { section in
            switch section {
            case .selectedImages:
                return UIColor(white: (236.0 / 255.0), alpha: 1.0)
            case .imageSources:
                return .white
            case .pickerView:
                return UIColor(white: (236.0 / 255.0), alpha: 1.0)
            }
        }

        flaneurPicker.config.sizeForImagesPickerView = { collectionSize in
            let nbOfColumns: CGFloat = 3.0
            let squareDimension: CGFloat = (collectionSize.width / nbOfColumns)
            return CGSize(width: squareDimension, height: squareDimension)
        }

        let paddingOfImages: CGFloat = 2.0
        flaneurPicker.config.paddingForImagesPickerView = UIEdgeInsets(top: paddingOfImages,
                                                                       left: paddingOfImages,
                                                                       bottom: paddingOfImages,
                                                                       right: paddingOfImages)

        let selfBundle = Bundle(for: FlaneurFormView.self)
        if let imageBundleURL = selfBundle.url(forResource: "FlaneurOpen", withExtension: "bundle") {
            if let imageBundle = Bundle(url: imageBundleURL) {
                flaneurPicker.config.imageForImageProvider = { imageProvider in
                    switch imageProvider.name {
                    case "library":
                        return UIImage(named: "libraryImageSource", in: imageBundle, compatibleWith: nil)
                    case "camera":
                        return UIImage(named: "cameraImageSource", in: imageBundle, compatibleWith: nil)
                    case "instagram":
                        return UIImage(named: "instagramImageSource", in: imageBundle, compatibleWith: nil)
                    default:
                        fatalError("found undefined imageProvider: \(imageProvider.name)")
                    }
                }
            } else {
                print("Bundle for FlaneurOpen images not found.")
            }
        } else {
            print("URL for FlaneurOpen images bundle not found.")
        }

        flaneurPicker.delegate = self

        delegate?.presentViewController(viewController: flaneurPicker)
    }
}

extension FlaneurFormImagePickerElementCollectionViewCell: FlaneurImagePickerControllerDelegate {
    func flaneurImagePickerController(_ picker: FlaneurImagePickerController, didFinishPickingImages images: [FlaneurImageDescriptor], userInfo: Any?) {
        self.currentSelection = images

        if let imageDelegate = imageDelegate {
            imageDelegate.flaneurImagePickerController(picker,
                                                       didFinishPickingImages: images,
                                                       userInfo: userInfo)
        }

        picker.dismiss(animated: true)
    }

    func flaneurImagePickerControllerDidCancel(_ picker: FlaneurImagePickerController) {
        if let imageDelegate = imageDelegate {
            imageDelegate.flaneurImagePickerControllerDidCancel(picker)
        }
        picker.dismiss(animated: true)
    }

    func flaneurImagePickerControllerDidFail(_ error: FlaneurImagePickerError) {
        debugPrint("ERROR: \(error)")
    }

    func flaneurImagePickerController(_ picker: FlaneurImagePickerController, withCurrentSelectionOfSize count: Int, actionForNewImageSelection newImage: FlaneurImageDescriptor) -> FlaneurImagePickerControllerAction {
        guard let imageDelegate = imageDelegate else {
            return .add
        }

        if imageDelegate.numberOfImages() == 1 {
            return count < 1 ? .add : .replaceLast
        } else {
            if count < imageDelegate.numberOfImages() {
                return .add
            } else {
                return .doNothing
            }
        }
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
