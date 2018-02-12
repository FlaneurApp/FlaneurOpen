//
//  KeyboardObserver.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 12/02/2018.
//

import Foundation

/// This is a convenience helper to manage keyboard appearances and disappearances.
///
/// ## Usage
///
/// Instanciate the object in your view controller's `viewWillAppear` to start observing notifications.
/// The object will stop observing notifications so as long as you don't have memory leaks, you don't
/// need to handle it anywhere else. Otherwise, just reinit your keyboard observer to `nil` and it will
/// stop observing.
final public class KeyboardObserver {
    private let observer1: NSObjectProtocol
    private let observer2: NSObjectProtocol

    /// Returns a newly initialized keyboard observer.
    ///
    /// - Parameters
    ///   - toggleKeyboardHandler: a handler that will be called inside a `UIView` animation block
    ///     with the height of the keyboard if it's appearing and `O` if it's hiding.
    public init(toggleKeyboardHandler: @escaping (CGFloat) -> ()) {
        observer1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil, using: { notification in
            KeyboardObserver.processNotification(notification, isShowing: true, toggleKeyboardHandler: toggleKeyboardHandler)
        })
        observer2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: { notification in
            KeyboardObserver.processNotification(notification, isShowing: false, toggleKeyboardHandler: toggleKeyboardHandler)
        })
    }

    static func processNotification(_ notification: Notification, isShowing: Bool, toggleKeyboardHandler: @escaping (CGFloat) -> ()) {
        guard let keyboardInfo = notification.userInfo else {
            fatalError("No keyboard info found")
        }

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

        var keyboardHeight: CGFloat = 0.0
        if isShowing {
            let keyboardFrame = (keyboardInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            keyboardHeight = keyboardFrame?.size.height ?? 0.0
        }

        if let animationDuration = (keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           options: animationOptions,
                           animations: {
                            toggleKeyboardHandler(keyboardHeight)
            })
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(observer1)
        NotificationCenter.default.removeObserver(observer2)
    }
}
