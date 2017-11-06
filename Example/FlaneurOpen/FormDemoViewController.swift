//
//  FormDemoViewController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen
import FlaneurImagePicker

class FormDemoViewController: UIViewController {
    @IBOutlet weak var formView: FlaneurFormView!
    @IBOutlet weak var formViewBottomConstraint: NSLayoutConstraint!

    var nameTextField: UITextField?
    var descriptionTextArea: UITextView?
    var didAppear = false
    var currentPictureSelection: [FlaneurImageDescription] = [
        FlaneurImageDescription(imageURLString: "https://images.unsplash.com/photo-1427434991195-f42379e2139d")!
    ]

    let categoriesDelegate = CategoriesSelectDelegate()

    deinit {
        print("deinit FormDemoViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        formView.configure(viewController: self)

        // Add form elements
        let nameFormElement = FlaneurFormElement(type: .textField, label: "Name") { [weak self] view in
            self?.nameTextField = view as? UITextField
            if self?.didAppear ?? false {
                self?.nameTextField?.becomeFirstResponder()
            }
        }
        formView.addFormElement(nameFormElement)

        let name2FormElement = FlaneurFormElement(type: .textField, label: "Name 2")
        formView.addFormElement(name2FormElement)

        let selectElement = FlaneurFormElement(type: .selectBis(delegate: categoriesDelegate), label: "My Great Select") { view in
            view.backgroundColor = .orange
        }
        formView.addFormElement(selectElement)

        let descriptionFormElement = FlaneurFormElement(type: .textArea, label: "Description") { [weak self] descriptionTextView in
            self?.descriptionTextArea = descriptionTextView as? UITextView
        }
        formView.addFormElement(descriptionFormElement)

        let imagePickerFormElement = FlaneurFormElement(type: .imagePicker(delegate: self), label: "Cover")
        formView.addFormElement(imagePickerFormElement)

        let description1FormElement = FlaneurFormElement(type: .textArea, label: "Description 1")
        formView.addFormElement(description1FormElement, cacheValue: "TEST CACHE")
        let description2FormElement = FlaneurFormElement(type: .textArea, label: "Description 2")
        formView.addFormElement(description2FormElement)
        let description3FormElement = FlaneurFormElement(type: .textArea, label: "Description 3")
        formView.addFormElement(description3FormElement)

        let selectElement2 = FlaneurFormElement(type: .select(delegate: self), label: "My 2nd Great Select") { view in
            view.backgroundColor = .purple
        }
        formView.addFormElement(selectElement2)

        let deleteElement = FlaneurFormElement(type: .delete(delegate: self), label: "Delete")
        formView.addFormElement(deleteElement)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)

        didAppear = true
        nameTextField?.becomeFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }

    func keyboardWillShow(notification: Notification) {
        guard let keyboardInfo = notification.userInfo else {
            print("WARN! No keyboard info")
            return
        }
        adjustFormView(keyboardShowing: true, keyboardInfo: keyboardInfo)
    }

    func keyboardWillHide(notification: Notification) {
        guard let keyboardInfo = notification.userInfo else {
            print("WARN! No keyboard info")
            return
        }
        adjustFormView(keyboardShowing: false, keyboardInfo: keyboardInfo)
    }

    func adjustFormView(keyboardShowing: Bool, keyboardInfo: [AnyHashable : Any]) {
        var animationOptions: UIViewAnimationOptions = []
        if let animationCurveInteger = (keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue {
            if let animationCurve = UIViewAnimationCurve(rawValue: animationCurveInteger) {
                switch animationCurve {
                case .easeIn:
                    animationOptions = .curveEaseIn
                case .easeOut:
                    animationOptions = .curveEaseOut
                case .easeInOut:
                    animationOptions = .curveEaseInOut
                case .linear:
                    animationOptions = .curveLinear
                }
            }
        }

        self.formView.setNeedsUpdateConstraints()

        if keyboardShowing {
            let keyboardFrame = (keyboardInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyboardHeight = keyboardFrame?.size.height
            formViewBottomConstraint.constant = keyboardHeight!
        } else {
            formViewBottomConstraint.constant = 0
        }

        if let animationDuration = (keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           options: animationOptions,
                           animations: {
                            self.view.layoutIfNeeded()
            })
        }
    }

    @IBAction func showFormValues(_ sender: Any? = nil) {
        let nameValue = nameTextField?.text ?? "-"
        let descriptionValue = descriptionTextArea?.text ?? "-"
        let message = "Name: \(nameValue)\nDescription: \(descriptionValue)"
        let alertController = UIAlertController(title: "Form Values", message: message, preferredStyle: .alert)

        let dismissAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(dismissAction)

        self.present(alertController, animated: true)
    }
}

extension FormDemoViewController: FlaneurFormImagePickerElementCollectionViewCellDelegate {
    func flaneurImagePickerController(_ picker: FlaneurImagePickerController, didFinishPickingImages images: [FlaneurImageDescription], userInfo: Any?) {
        print("didPickImages: \(images.count)")
        self.currentPictureSelection = images
    }

    func flaneurImagePickerControllerDidCancel(_ picker: FlaneurImagePickerController) {
        print("didCancel")
    }

    func buttonImage() -> UIImage {
        return UIImage(named: "sample-405-test-tube")!
    }

    func sourceDelegates() -> [FlaneurImageSource] {
        return [ .library, .camera ]
    }

    func numberOfImages() -> Int {
        return 2
    }

    func initialSelection() -> [FlaneurImageDescription] {
        return currentPictureSelection
    }
}

extension FormDemoViewController: FlaneurFormSelectElementCollectionViewCellDelegate {
    func nbOfItems() -> Int {
        return 10
    }

    func selectCollectionViewHeight() -> CGFloat {
        return 54.0
    }

    func cellClass() -> AnyClass? {
        return DemoCollectionViewCell.self
    }

    func cellReuseIdentifier() -> String {
        return "formElementCell"
    }

    func configure(cell: UICollectionViewCell, forIndex: Int) {
        guard let demoCell = cell as? DemoCollectionViewCell else {
            fatalError("configuration error")
        }

        demoCell.label.text = "\(forIndex)"
    }

    func allowMultipleSelection() -> Bool {
        return true
    }

    func didSelectItem(index: Int, cell: UICollectionViewCell) {
        debugPrint("didSelect \(index)")
    }

    func didDeselectItem(index: Int, cell: UICollectionViewCell) {
        debugPrint("didDeselectItem \(index)")
    }
}

extension FormDemoViewController: FlaneurFormDeleteElementCollectionViewCellDelegate {
    func flaneurFormCellDidRequestDeletion() {
        print("didRequestDeletion")
    }
}

class CategoriesSelectDelegate: FlaneurFormSelectElementCollectionViewCellDelegate {
    func selectCollectionViewSize() -> CGSize {
        return CGSize(width: 54.0, height: 54.0)
    }

    func nbOfItems() -> Int {
        return 9
    }

    func cellClass() -> AnyClass? {
        return DemoCollectionViewCell.self
    }

    func cellReuseIdentifier() -> String {
        return "formElementCell"
    }

    func configure(cell: UICollectionViewCell, forIndex: Int) {
        guard let demoCell = cell as? DemoCollectionViewCell else {
            fatalError("configuration error")
        }

        demoCell.label.text = "\(forIndex)"
    }

    func allowMultipleSelection() -> Bool {
        return true
    }

    func didSelectItem(index: Int, cell: UICollectionViewCell) {
        debugPrint("didSelect \(index)")
    }

    func didDeselectItem(index: Int, cell: UICollectionViewCell) {
        debugPrint("didDeselect \(index)")
    }
}
