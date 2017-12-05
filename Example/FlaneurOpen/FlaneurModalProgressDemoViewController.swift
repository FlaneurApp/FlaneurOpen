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
    var animationDuration: CFTimeInterval = 3.0
    var modalProgressViewController: FlaneurModalProgressViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImageView.alpha = 0.0
    }

    func createDisplayLink() {
        progress = Progress(totalUnitCount: Int64(animationDuration * 1000))
        startDate = nil

        let displayLink =  CADisplayLink(target: self, selector: #selector(step(displaylink:)))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
    }

    @objc func step(displaylink: CADisplayLink) {
        if startDate == nil {
            startDate = displaylink.timestamp
        }

        let elapsed: CFTimeInterval = displaylink.timestamp - startDate!
        self.progress.completedUnitCount = Int64(elapsed * 1000)

        debugPrint("Progress: \(self.progress.fractionCompleted), elapsed: \(elapsed)")
        self.backgroundImageView.alpha = CGFloat(self.progress.fractionCompleted)

        if elapsed >= animationDuration {
            displaylink.invalidate()

            self.modalProgressViewController?.configureWithFinalState(body: "Demo completed.")
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.modalProgressViewController?.progressBar.isHidden = true
                            self.modalProgressViewController?.bodyLabel.isHidden = false
            })
        }
    }

    @IBAction func launchModalAction(_ sender: Any? = nil) {
        self.createDisplayLink()

        let modalProgressViewController = FlaneurModalProgressViewController()
        self.modalProgressViewController = modalProgressViewController
        modalProgressViewController.topPadding = self.topLayoutGuide.length
        modalProgressViewController.modalPresentationStyle = .overCurrentContext
        modalProgressViewController.delegate = self
        modalProgressViewController.configureWithInProgressState(title: "In progress",
                                                                 body: "Please wait",
                                                                 progress: self.progress)
        self.present(modalProgressViewController, animated: true)
    }

    deinit {
        debugPrint("deinit")
    }
}

extension FlaneurModalProgressDemoViewController: FlaneurModalProgressViewControllerDelegate {
    func modalProgressControllerDidComplete(_ viewController: FlaneurModalProgressViewController) {
        self.modalProgressViewController = nil
        viewController.dismiss(animated: true)
    }
}
