//
//  FlaneurModalProgressViewController.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 05/10/2017.
//

import UIKit

public protocol FlaneurModalProgressViewControllerDelegate: AnyObject {
    func modalProgressControllerDidComplete(_ viewController: FlaneurModalProgressViewController)
}

final public class FlaneurModalProgressViewController: UIViewController {
    public var topPadding: CGFloat = 0.0

    public private(set) var titleLabel: UILabel = UILabel(frame: .zero)
    public private(set) var bodyLabel: UILabel = UILabel(frame: .zero)
    public private(set) var progressBar: UIProgressView = UIProgressView(progressViewStyle: .default)
    private var finalStateReached: Bool = false

    public weak var delegate: FlaneurModalProgressViewControllerDelegate? = nil

    deinit {
        ()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false

        let popup = UIView(frame: .zero)
        popup.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        popup.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(popup)
        _ = LayoutBorderManager(item: popup,
                                toItem: view,
                                top: topPadding,
                                left: 0.0,
                                bottom: 0.0,
                                right: 0.0)

        // Setup the progress bar
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(progressBar)
        _ = LayoutBorderManager(item: progressBar,
                                toItem: popup,
                                top: 0.0,
                                left: 0.0,
                                right: 0.0)

        bodyLabel.textColor = .white
        bodyLabel.numberOfLines = 2
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.textAlignment = .center
        popup.addSubview(bodyLabel)
        _ = LayoutBorderManager(item: bodyLabel,
                                toItem: popup,
                                left: 15.0,
                                right: 15.0)
        NSLayoutConstraint(item: bodyLabel,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: popup,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true

        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        popup.addSubview(titleLabel)
        _ = LayoutBorderManager(item: titleLabel,
                                toItem: popup,
                                top: 90.0,
                                left: 45.0,
                                right: 45.0)
    }
    
    public func configureWithInProgressState(title: String? = nil,
                                             body: String? = nil,
                                             progress: Progress? = nil) {
        if !finalStateReached {
            titleLabel.text = title
            bodyLabel.text = body
            progressBar.observedProgress = progress
        }
    }

    public func configureWithFinalState(title: String? = nil,
                                        body: String? = nil,
                                        hideProgress: Bool = false) {
        finalStateReached = true
        titleLabel.text = title
        bodyLabel.text = body
        progressBar.isHidden = hideProgress

        delegate?.modalProgressControllerDidComplete(self)
    }
}
