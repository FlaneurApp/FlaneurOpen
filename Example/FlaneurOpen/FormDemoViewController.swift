//
//  FormDemoViewController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen


class FormDemoViewController: UIViewController {
    @IBOutlet weak var formView: FlaneurFormView!
    @IBOutlet weak var formViewBottomConstraint: NSLayoutConstraint!

    var firstResponderView: UIView?
    var didAppear = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        formView.configure(viewController: self)
        let nameFormElement = FlaneurFormElement(type: .textField, label: "Name") { view in
            self.firstResponderView = view
            if self.didAppear {
                self.firstResponderView?.becomeFirstResponder()
            }
        }
        formView.addFormElement(nameFormElement)

        let descriptionFormElement = FlaneurFormElement(type: .textArea, label: "Description")
        formView.addFormElement(descriptionFormElement)

        let imagePickerFormElement = FlaneurFormElement(type: .imagePicker, label: "Cover")
        formView.addFormElement(imagePickerFormElement)

        let description1FormElement = FlaneurFormElement(type: .textArea, label: "Description 1")
        formView.addFormElement(description1FormElement)
        let description2FormElement = FlaneurFormElement(type: .textArea, label: "Description 2")
        formView.addFormElement(description2FormElement)
        let description3FormElement = FlaneurFormElement(type: .textArea, label: "Description 3")
        formView.addFormElement(description3FormElement)
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
        firstResponderView?.becomeFirstResponder()
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
            debugPrint("Keyboard height: ", keyboardHeight)
            formViewBottomConstraint.constant += keyboardHeight!
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
}
