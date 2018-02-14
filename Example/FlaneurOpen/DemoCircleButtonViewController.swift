//
//  DemoCircleButtonViewController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 13/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen

class DemoCircleButtonViewController: UIViewController {
    let circleButton = CircleButton()

    let widthStepper = UIStepper()
    let heightStepper = UIStepper()

    var buttonWidth: NSLayoutConstraint?
    var buttonHeight: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(circleButton)
        view.addSubview(widthStepper)
        view.addSubview(heightStepper)

        view.backgroundColor = .white
        circleButton.backgroundColor = .yellow

        circleButton.translatesAutoresizingMaskIntoConstraints = false
        widthStepper.translatesAutoresizingMaskIntoConstraints = false
        heightStepper.translatesAutoresizingMaskIntoConstraints = false

        let defaultDimension: CGFloat = 50.0
        buttonWidth = circleButton.widthAnchor.constraint(equalToConstant: defaultDimension)
        buttonHeight = circleButton.heightAnchor.constraint(equalToConstant: defaultDimension)

        NSLayoutConstraint.activate([
            circleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            circleButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8.0),
            widthStepper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            widthStepper.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8.0),
            heightStepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            heightStepper.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8.0),
            //buttonWidth!,
            //buttonHeight!
            ])

        widthStepper.addTarget(self, action: #selector(dimensionChanged(_:)), for: .touchUpInside)
        widthStepper.value = Double(buttonWidth?.constant ?? 0.0)
        widthStepper.minimumValue = 0.0
        widthStepper.maximumValue = 100.0
        widthStepper.stepValue = 1.0

        heightStepper.addTarget(self, action: #selector(dimensionChanged(_:)), for: .touchUpInside)
        heightStepper.value = Double(buttonHeight?.constant ?? 0.0)
        heightStepper.minimumValue = 0.0
        heightStepper.maximumValue = 100.0
        heightStepper.stepValue = 1.0

        circleButton.setImage(UIImage(named: "radial-gradient"), for: .normal)
        circleButton.setTitle("Test", for: .normal)
        circleButton.setTitleColor(.black, for: .normal)
    }

    @IBAction func dimensionChanged(_ sender: Any?) {
        guard let stepper = sender as? UIStepper else { return }

        if (stepper == widthStepper) {
            buttonWidth?.constant = CGFloat(stepper.value)
        }

        if (stepper == heightStepper) {
            buttonHeight?.constant = CGFloat(stepper.value)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
