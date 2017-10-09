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
    var progress: Progress!
    var startDate: CFTimeInterval? = nil
    var animationDuration: Int64 = 3
    var modalProgressViewController: FlaneurModalProgressViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImageView.alpha = 0.0
        self.progress = Progress(totalUnitCount: animationDuration * 1000)
    }

    func createDisplayLink() {
        let displayLink =  CADisplayLink(target: self, selector: #selector(step(displaylink:)))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
    }

    func step(displaylink: CADisplayLink) {
        if startDate == nil {
            startDate = displaylink.timestamp
        }

        let elapsed: CFTimeInterval = displaylink.timestamp - startDate!
        self.progress.completedUnitCount = Int64(elapsed * 1000)

        self.backgroundImageView.alpha = CGFloat(self.progress.fractionCompleted)

        if elapsed >= CFTimeInterval(animationDuration) {
            displaylink.invalidate()

            self.modalProgressViewController?.bodyLabel.text = "Demo completed."
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.modalProgressViewController?.progressBar.isHidden = true
                            self.modalProgressViewController?.bodyLabel.isHidden = false
                            self.modalProgressViewController?.okButton.isEnabled = true
            })
        }
    }

    @IBAction func launchModalAction(_ sender: Any? = nil) {
        self.createDisplayLink()
        modalProgressViewController = FlaneurModalProgressViewController(nibName: nil, bundle: nil)
        modalProgressViewController!.modalPresentationStyle = .overCurrentContext
        self.present(modalProgressViewController!, animated: true) {
            self.modalProgressViewController?.progressBar.observedProgress = self.progress
        }
    }
}
