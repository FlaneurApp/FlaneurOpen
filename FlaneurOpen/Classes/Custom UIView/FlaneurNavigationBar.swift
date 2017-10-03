//
//  FlaneurNavigationBar.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 07/09/2017.
//
//

import UIKit
import Kingfisher

fileprivate let defaultTitleLabelTrailingValue: CGFloat = 16.0

public enum FlaneurNavigationBarActionFaceView {
    case image(UIImage)
    case label(String)
}

/// The structure describing:
///
/// * how the associated control should look like
/// * what the associated controld should do when tapped
public struct FlaneurNavigationBarAction {
    let faceView: FlaneurNavigationBarActionFaceView
    var action: () -> () = { _ in
        debugPrint("FlaneurNavigationBarAction pressed. Please override this attribute.")
    }

    /// Returns an action.
    ///
    /// The associated control will be a `UIButton` with an image.
    ///
    /// - Parameters:
    ///   - image: the *face view* to be used on the `UIButton` associated to the action.
    ///   - action: the action to perform when the `UIButton` receives a `.touchUpInside` event.
    public init(faceView: FlaneurNavigationBarActionFaceView, action: @escaping () -> ()) {
        self.faceView = faceView
        self.action = action
    }
}

/// A visual control aiming to reproduce the visual aspect of a `UINavigationBar`, with a custom height size,
/// but without the functional part requiring a `UINavigationController`.
///
/// ## Overview
///
/// A `FlaneurNavigationBar` is a bar, typically displayed at the top of the window, containing buttons that
/// can be easily customized with blocks. The primary components are a left button, a title, and an optional
/// array of right buttons. You must use a flaneur navigation bar as a standalone object. It has no compatibility
/// whatsoever with a navigation controller object.
///
/// ## Behaviors
///
/// When a left action is configured, then the whole navigation bar actions it. It does not interfere with
/// the right buttons.
///
/// ## Using a FlaneurNavigationBar
///
/// If you're using a storyboard to instanciate your views, you should try to use a height of 66 pt.
/// After placing the view, you can configure its content programmatically:
///
///     @IBOutlet weak var navigationBar: FlaneurNavigationBar!
///
///     let leftAction = FlaneurNavigationBarAction(image: ...) { _ in
///         ...
///     }
///
///     self.navigationBar.configure(title: ...,
///                                  leftAction: myLeftAction)
///
/// ## Customizing the appearance of the bar via `UIAppearance`
///
/// You can customize the appearance of a `FlaneurNavigationBar` via `UIAppearance` so that it has a consistent
/// appearance in your app with unique lines of code.
///
/// For instance, the following code makes the title of the bar use the Futura font everywhere in your app:
///
///     UILabel.appearance(whenContainedInInstancesOf: [FlaneurNavigationBar.self]).font = UIFont(name: "Futura-Medium", size: 16.0)
///
/// ## Demo
///
/// The FlaneurOpen demo app includes a demo for `FlaneurNavigationBar`. Cf. `FlaneurNavigationBarDemoViewController`.
final public class FlaneurNavigationBar: UIView {
    var titleLabel: UILabel!
    var leftButton: UIButton!
    public private(set) var rightButtons: [UIButton]!

    var titleLabelTrailingLayoutConstraint: NSLayoutConstraint!
    var titleLabelTrailingLayoutConstraintToRightestButton: NSLayoutConstraint?

    var leftButtonAction: () -> () = { _ in
    }

    var rightButtonsActions: [() -> ()] = []

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

    // MARK: - Configuring the bar

    /// Configures the bar with content.
    ///
    /// This method should only be called once per instance.
    ///
    /// - Parameters:
    ///   - title: The string to set as the title displayed in the center of the navigation bar.
    ///   - leftAction: An optional custom action. The associated control will be displayed on the left edge of the navigation bar.
    ///   - rightActions: An optional array of custom actions. The associated controls will be displayed on the right edge of the navigation bar. The first item will be the closest from the right edge (ie controls will be displayed right-to-left)
    public func configure(title: String,
                          leftAction: FlaneurNavigationBarAction? = nil,
                          rightActions: [FlaneurNavigationBarAction]? = nil) {
        var titleLabelLeadingValue: CGFloat = 16.0

        if let leftAction = leftAction {
            titleLabelLeadingValue = 42.0

            // Setting up button
            leftButton.imageView?.contentMode = .scaleAspectFit
            leftButton.imageView?.tintColor = .black

            switch leftAction.faceView {
            case .image(let image):
                leftButton.setImage(image, for: .normal)
            case .label(let label):
                leftButton.setTitle(label, for: .normal)
            }

            leftButton.showsTouchWhenHighlighted = true
            leftButton.isUserInteractionEnabled = true
            leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
            addSubview(leftButton)

            leftButtonAction = leftAction.action

            // If there is a left action, the title view activates it
            let tagGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(leftButtonPressed))
            tagGestureRecognizer.numberOfTapsRequired = 1
            titleLabel.addGestureRecognizer(tagGestureRecognizer)
            titleLabel.isUserInteractionEnabled = true

            // Setting up button's constraint
            leftButton.translatesAutoresizingMaskIntoConstraints = false
            let buttonSize: CGFloat = 24.0

            // Set the leading space to 8.0 point
            NSLayoutConstraint(item: leftButton,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 8.0).isActive = true
            // Center vertically
            NSLayoutConstraint(item: leftButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            // Give a square width & height
            NSLayoutConstraint(item: leftButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonSize).isActive = true
            NSLayoutConstraint(item: leftButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonSize).isActive = true
        }

        // Setting up title
        self.setTitle(title)
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        addSubview(titleLabel)

        // Setting up title's constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titleLabel,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: titleLabelLeadingValue).isActive = true
        titleLabelTrailingLayoutConstraint = NSLayoutConstraint(item: titleLabel,
                                                                attribute: .trailing,
                                                                relatedBy: .equal,
                                                                toItem: self,
                                                                attribute: .trailing,
                                                                multiplier: 1.0,
                                                                constant: -defaultTitleLabelTrailingValue)
        titleLabelTrailingLayoutConstraint.isActive = true
        NSLayoutConstraint(item: titleLabel,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true

        if let rightActions = rightActions {
            setupRightActions(rightActions)
        }
    }

    func setupRightActions(_ rightActions: [FlaneurNavigationBarAction]) {
        var rightestView: UIView = self

        // Remove old buttons
        for oldRightButton in rightButtons {
            oldRightButton.removeFromSuperview()
            oldRightButton.removeTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
        }

        // Add the new image buttons
        if isOnlyImageRightActions(actions: rightActions) {
            for index in 0..<rightActions.count {
                let rightAction = rightActions[index]
                let newRightButton = UIButton(type: .custom)
                rightButtons.append(newRightButton)
                rightButtonsActions.append(rightAction.action)

                // Setting up button
                newRightButton.imageView?.contentMode = .scaleAspectFit
                newRightButton.imageView?.tintColor = .black

                switch rightAction.faceView {
                case .image(let image):
                    newRightButton.setImage(image, for: .normal)
                default:
                    fatalError("Right actions without image shouldn't be processed here")
                }

                newRightButton.showsTouchWhenHighlighted = true
                newRightButton.isUserInteractionEnabled = true
                newRightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
                addSubview(newRightButton)

                // Setting up button's constraints
                newRightButton.translatesAutoresizingMaskIntoConstraints = false
                let buttonSize: CGFloat = 24.0

                // Set the trailing space to 8.0 point
                let space: CGFloat = -18.0 + CGFloat(index) * (-24.0 - 12.0)
                NSLayoutConstraint(item: newRightButton,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .trailing,
                                   multiplier: 1.0,
                                   constant: space).isActive = true
                // Center vertically
                NSLayoutConstraint(item: newRightButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
                // Give a square width & height
                NSLayoutConstraint(item: newRightButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonSize).isActive = true
                NSLayoutConstraint(item: newRightButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonSize).isActive = true

                rightestView = newRightButton
            }
        } else if isUniqueTextAction(actions: rightActions) {
            let rightAction = rightActions[0]
            let newRightButton = UIButton(type: .custom)
            rightButtons.append(newRightButton)
            rightButtonsActions.append(rightAction.action)

            switch rightAction.faceView {
            case .label(let title):
                newRightButton.setTitle(title, for: .normal)
                newRightButton.setTitleColor(.black, for: .normal)
                newRightButton.setTitleColor(.gray, for: .disabled)
            default:
                fatalError("Right actions without text shouldn't be processed here")
            }

            newRightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
            addSubview(newRightButton)

            newRightButton.translatesAutoresizingMaskIntoConstraints = false

            // Set the trailing space to 8.0 point
            let space: CGFloat = -18.0
            NSLayoutConstraint(item: newRightButton,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: space).isActive = true
            // Center vertically
            NSLayoutConstraint(item: newRightButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            // Set width
            let sizeToFit = newRightButton.sizeThatFits(.zero)
            NSLayoutConstraint(item: newRightButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: sizeToFit.width).isActive = true


            rightestView = newRightButton
        } else if rightActions.count > 0 {
            print("ERROR! invalid right buttons, check the doc")
        }

        // Adjust constraint to rightest view
        if rightestView == self {
            titleLabelTrailingLayoutConstraint.isActive = true
            titleLabelTrailingLayoutConstraintToRightestButton?.isActive = false
        } else {
            titleLabelTrailingLayoutConstraint.isActive = false
            titleLabelTrailingLayoutConstraintToRightestButton = NSLayoutConstraint(item: titleLabel,
                                                                                    attribute: .trailing,
                                                                                    relatedBy: .equal,
                                                                                    toItem: rightestView,
                                                                                    attribute: .leading,
                                                                                    multiplier: 1.0,
                                                                                    constant: -8.0)
            titleLabelTrailingLayoutConstraintToRightestButton?.isActive = true
        }
    }

    /// Sets the title.
    ///
    /// - Parameter title: The string to set as the title displayed in the center of the navigation bar.
    public func setTitle(_ title: String) {
        titleLabel.flaneurText(title, letterSpacing: 2.0)
    }

    public func setRightActions(_ rightActions: [FlaneurNavigationBarAction]) {
        setupRightActions(rightActions)
    }

    func isOnlyImageRightActions(actions: [FlaneurNavigationBarAction]) -> Bool {
        for action in actions {
            switch action.faceView {
            case .image:
                continue
            default:
                return false
            }
        }

        return actions.count > 0
    }

    func isUniqueTextAction(actions: [FlaneurNavigationBarAction]) -> Bool {
        if actions.count == 1 {
            switch actions[0].faceView {
            case .label:
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }

    // MARK: - Actions

    @IBAction func leftButtonPressed(_ sender: Any) {
        leftButtonAction()
    }

    @IBAction func rightButtonPressed(_ sender: Any) {
        if let senderButton = sender as? UIButton {
            if let buttonIndex = rightButtons.index(where: { $0 == senderButton }) {
                rightButtonsActions[buttonIndex]()
            } else {
                debugPrint("Sender not found in rightButtons", sender)
            }
        } else {
            debugPrint("Sender is not a UIButton: ", sender)
        }
    }

    // MARK: - Private Code

    /// Common init code.
    func didLoad() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        titleLabel = UILabel(frame: .zero)
        leftButton = UIButton(frame: .zero)
        rightButtons = []
        createBottomBorder()
        clipsToBounds = true
    }
}
