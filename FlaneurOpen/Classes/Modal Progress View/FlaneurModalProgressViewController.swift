//
//  FlaneurModalProgressViewController.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 05/10/2017.
//

import UIKit

final public class FlaneurModalProgressViewController: UIViewController {
    public private(set) var titleLabel: UILabel!
    public private(set) var bodyLabel: UILabel!
    public private(set) var okButton: UIButton!
    public private(set) var progressBar: UIProgressView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false

        let popup = UIView(frame: .zero)
        popup.backgroundColor = .white
        popup.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(popup)
        _ = LayoutBorderManager(item: popup,
                                toItem: view,
                                top: 180.0,
                                left: 15.0,
                                bottom: 180.0,
                                right: 15.0)

        // Setup the progress bar
        progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(progressBar)
        _ = LayoutBorderManager(item: progressBar,
                                toItem: popup,
                                left: 15.0,
                                right: 15.0)
        NSLayoutConstraint(item: progressBar,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: popup,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true

        titleLabel = UILabel(frame: .zero)
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        popup.addSubview(titleLabel)
        _ = LayoutBorderManager(item: titleLabel,
                                toItem: popup,
                                top: 90.0,
                                left: 45.0,
                                right: 45.0)

        okButton = UIButton(type: .custom)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.backgroundColor = .black
        okButton.setTitleColor(.white, for: .normal)
        okButton.setTitleColor(.gray, for: .disabled)
        okButton.isEnabled = false
        okButton.contentEdgeInsets = UIEdgeInsetsMake(14.0, 60.0, 14.0, 60.0)
        okButton.setTitle("OK", for: .normal)
        okButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        popup.addSubview(okButton)
        _ = LayoutBorderManager(item: okButton,
                                toItem: popup,
                                bottom: 50.0)
        NSLayoutConstraint(item: okButton,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: popup,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true

    }
    
    @IBAction func dismiss(_ sender: Any? = nil) {
        self.dismiss(animated: true)
    }
}
