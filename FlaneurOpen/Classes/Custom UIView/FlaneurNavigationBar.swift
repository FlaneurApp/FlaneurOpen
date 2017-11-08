//
//  FlaneurNavigationBar.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 07/09/2017.
//
//

import UIKit
import Kingfisher

fileprivate extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

fileprivate extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}

fileprivate let defaultContainerWidth: CGFloat = 16.0

fileprivate let leftButtonSize: CGFloat = 24.0
fileprivate let rightButtonSize: CGFloat = 36.0
fileprivate let rightInBetweenButtonSpace: CGFloat = 4.0

public enum FlaneurNavigationBarActionFaceView {
    case image(UIImage)
    case imageToggle(UIImage, UIImage)
    case label(String)
    case customView(UIView)
}

/// The structure describing:
///
/// * how the associated control should look like
/// * what the associated controld should do when tapped
public struct FlaneurNavigationBarAction {
    let faceView: FlaneurNavigationBarActionFaceView
    var action: () -> () = { _ in
        print("INFO: FlaneurNavigationBarAction pressed. Please override this attribute.")
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
    var leftContainer: UIView!
    var rightContainer: UIView!

    var leftContainerWidthConstraint: NSLayoutConstraint!
    var rightContainerWidthConstraint: NSLayoutConstraint!

    public private(set) var rightButtons: [UIButton] = []

    var leftButtonAction: () -> () = { _ in }
    var rightButtonsActions: [() -> ()] = []

    public var debug: Bool = false

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

    /// Common init code.
    func didLoad() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white

        // Init the left container
        leftContainer = UIView(frame: .zero)
        leftContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftContainer)
        _ = LayoutBorderManager.init(item: leftContainer,
                                     toItem: self,
                                     top: 0,
                                     left: 0,
                                     bottom: 0)
        leftContainerWidthConstraint = NSLayoutConstraint(item: leftContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: defaultContainerWidth)
        leftContainerWidthConstraint.isActive = true

        // Init the right container
        rightContainer = UIView(frame: .zero)
        rightContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightContainer)
        _ = LayoutBorderManager.init(item: rightContainer,
                                     toItem: self,
                                     top: 0,
                                     bottom: 0,
                                     right: 0)
        rightContainerWidthConstraint = NSLayoutConstraint(item: rightContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: defaultContainerWidth)
        rightContainerWidthConstraint.isActive = true

        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        self.addSubview(titleLabel)

        let views: [String: Any] = [
            "lView": leftContainer,
            "rView": rightContainer,
            "tLabel": titleLabel
        ]
        let formatString = "[lView]-0-[tLabel]-16-[rView]"
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: formatString, options: .alignAllCenterY, metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
        _ = LayoutBorderManager.init(item: titleLabel,
                                     toItem: self,
                                     top: 0,
                                     bottom: 0)
        _ = createBottomBorder()
        clipsToBounds = true
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
        self.setTitle(title)
        setLeftAction(leftAction)
        setRightActions(rightActions)

        if debug {
            leftContainer.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.1)
            titleLabel.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.1)
            rightContainer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.1)

            rightContainer.subviews.forEach { subview in
                subview.backgroundColor = .random
            }
        }
    }

    /// Sets the title.
    ///
    /// - Parameter title: The string to set as the title displayed in the center of the navigation bar.
    public func setTitle(_ title: String) {
        titleLabel.flaneurText(title, letterSpacing: 2.0)
    }

    public func setLeftAction(_ leftAction: FlaneurNavigationBarAction?) {
        // Reset state
        leftContainer.removeAllSubviews()
        leftButtonAction = { _ in }

        let horizontalPaddingForButton: CGFloat = 8.0

        // We want the leftContainer and the titleLabel to touch each other
        // otherwise, there might be a gap between them where touch does not trigger the action
        let activatingViews = [ leftContainer, titleLabel ]
        let paddingToLabelForContinuousTouchZone: CGFloat = 2.0

        if let leftAction = leftAction {
            leftButtonAction = leftAction.action

            let view = leftAction.view(size: leftButtonSize)
            view.isUserInteractionEnabled = false // Forward to the left container
            leftContainer.addSubview(view)

            // If there is a left action, the title view activates it
            for activatingView in activatingViews {
                activatingView?.respondsToTap(target: self, action: #selector(leftButtonPressed))
            }

            // Setting up button's constraint
            view.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint(item: view,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: leftContainer,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: horizontalPaddingForButton).isActive = true
            // Center vertically
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: leftContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            // Give a square width & height
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.width).isActive = true
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.height).isActive = true

            leftContainerWidthConstraint.constant = 2.0 * horizontalPaddingForButton + view.frame.width + paddingToLabelForContinuousTouchZone
        } else {
            for activatingView in activatingViews {
                activatingView?.removeAllGestureRecognizers()
            }

            leftContainerWidthConstraint.constant = 2.0 * horizontalPaddingForButton + paddingToLabelForContinuousTouchZone
        }
    }

    public func setRightActions(_ rightActions: [FlaneurNavigationBarAction]?) {
        rightContainer.removeAllSubviews()
        rightButtons = []
        rightButtonsActions = []

        if let rightActions = rightActions {
            guard self.isOnlyImageRightActions(actions: rightActions) || self.isUniqueTextAction(actions: rightActions) || rightActions.count == 0 else {
                print("ERROR: Invalid right button configuration for FlaneurNavigationBar")
                return
            }

            // Add the new image buttons
            var latestRightWidth: CGFloat = 0.0
            for index in 0..<rightActions.count {

                let rightAction = rightActions[index]

                let newRightButton = rightAction.view(size: rightButtonSize) as! UIButton
                rightButtons.append(newRightButton)
                rightButtonsActions.append(rightAction.action)
                newRightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
                rightContainer.addSubview(newRightButton)

                // Set the trailing space to 8.0 point
                newRightButton.translatesAutoresizingMaskIntoConstraints = false

                let space = rightSpaceForIndex(index: index)
                NSLayoutConstraint(item: newRightButton,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: rightContainer,
                                   attribute: .trailing,
                                   multiplier: 1.0,
                                   constant: -space).isActive = true
                // Center vertically
                NSLayoutConstraint(item: newRightButton, attribute: .centerY, relatedBy: .equal, toItem: rightContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
                // Give a square width & height
                NSLayoutConstraint(item: newRightButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: newRightButton.frame.width).isActive = true
                NSLayoutConstraint(item: newRightButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: newRightButton.frame.height).isActive = true

                latestRightWidth = space + newRightButton.frame.width
            }

            rightContainerWidthConstraint.constant = latestRightWidth
        } else {
            rightContainerWidthConstraint.constant = 0.0
        }
    }

    func rightSpaceForIndex(index: Int) -> CGFloat {
        // Default trailing space is 18.0
        // The we have a 24.0 button and a 12.0 space
        return 10.0 + CGFloat(index) * (rightButtonSize + rightInBetweenButtonSpace)
    }

    func isOnlyImageRightActions(actions: [FlaneurNavigationBarAction]) -> Bool {
        for action in actions {
            switch action.faceView {
            case .image, .imageToggle:
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
            senderButton.isSelected = !senderButton.isSelected
            if let buttonIndex = rightButtons.index(where: { $0 == senderButton }) {
                rightButtonsActions[buttonIndex]()
            } else {
                print("ERROR: Sender not found in rightButtons", sender)
            }
        } else {
            print("ERROR: Sender is not a UIButton: ", sender)
        }
    }
}

extension FlaneurNavigationBarAction {
    func view(size: CGFloat) -> UIView {
        switch self.faceView {
        case .image(let image):
            return viewForImageFaceView(defaultStateImage: image, size: size)
        case .imageToggle(let image1, let image2):
            return viewForImageFaceView(defaultStateImage: image1, optionalImage: image2, size: size)
        case .label(let labelTitle):
            return viewForLabelFaceView(title: labelTitle)
        case .customView(let view):
            return view
        }
    }

    func viewForImageFaceView(defaultStateImage: UIImage,
                              optionalImage: UIImage? = nil,
                              size: CGFloat = leftButtonSize) -> UIButton {
        let resultButton = UIButton(frame: CGRect(x: 0.0,
                                                  y: 0.0,
                                                  width: size,
                                                  height: size))

        // Setting up button
        resultButton.imageView?.contentMode = .scaleAspectFit
        resultButton.imageView?.tintColor = .black
        resultButton.setImage(defaultStateImage, for: .normal)

        // After a size of 24.0, we add some insets to keep the image being shown
        // at a 24 x 24 size (the insets space will still be tappable).
        if size > 24.0 {
            let edge: CGFloat = (size - 24.0) / 2.0
            resultButton.contentEdgeInsets = UIEdgeInsetsMake(edge, edge, edge, edge)
        }

        if let optionalImage = optionalImage {
            resultButton.setImage(optionalImage, for: .selected)
        }

        return resultButton
    }

    func viewForLabelFaceView(title: String) -> UIButton {
        let resultButton = UIButton(frame: .zero)
        resultButton.setTitle(title, for: .normal)
        resultButton.setTitleColor(.black, for: .normal)
        resultButton.setTitleColor(.gray, for: .disabled)
        resultButton.sizeToFit()
        return resultButton
    }
}
