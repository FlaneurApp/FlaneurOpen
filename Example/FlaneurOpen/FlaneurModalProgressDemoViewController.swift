//
//  FlaneurModalProgressDemoViewController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 05/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen

class FlaneurModalProgressDemoViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImageView.alpha = 0.0
    }

    @IBAction func launchModalAction(_ sender: Any? = nil) {
        let modalProgressViewController = FlaneurModalProgressViewController(nibName: nil, bundle: nil)
        modalProgressViewController.modalPresentationStyle = .overCurrentContext
        self.present(modalProgressViewController, animated: true) {
            modalProgressViewController.titleLabel.text = "My Demo Modal"
            UIView.animate(withDuration: 3.0,
                           animations: {
                            self.backgroundImageView.alpha = 1.0
            }, completion: { finished in
                modalProgressViewController.okButton.isEnabled = true
            })
        }
    }
}
