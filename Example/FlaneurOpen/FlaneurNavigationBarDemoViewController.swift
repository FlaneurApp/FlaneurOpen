//
//  FlaneurNavigationBarDemoViewController.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 07/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen

class FlaneurNavigationBarDemoViewController: UIViewController {
    @IBOutlet weak var navigationBar: FlaneurNavigationBar!

    var isDefaultLeftAction: Bool = false
    var myDefaultLeftAction: FlaneurNavigationBarAction!
    var myLongerLeftAction: FlaneurNavigationBarAction!

    override func viewDidLoad() {
        super.viewDidLoad()

        UILabel.appearance(whenContainedInInstancesOf: [FlaneurNavigationBar.self]).font = UIFont(name: "Futura-Medium", size: 16.0)

        myDefaultLeftAction = FlaneurNavigationBarAction(faceView: .image(UIImage(named: "sample-844-trumpet")!)) {
            self.navigationController?.popViewController(animated: true)
        }

        let myLongView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 10.0))
        myLongView.translatesAutoresizingMaskIntoConstraints = false
        myLongView.backgroundColor = .orange

        myLongerLeftAction = FlaneurNavigationBarAction(faceView: .customView(myLongView)) { _ in
            self.navigationController?.popViewController(animated: true)
        }

        self.navigationBar.configure(title: "My Super Very Long Navigation Bar Title".uppercased(),
                                     leftAction: myDefaultLeftAction,
                                     rightActions: imageRightActions())
        isDefaultLeftAction = true
    }

    func imageRightActions() -> [FlaneurNavigationBarAction] {
        let myFirstRightAction = FlaneurNavigationBarAction(faceView: .image(UIImage(named: "sample-986-ghost")!)) { _ in
            let alertViewController = UIAlertController(title: "My 1st Alert", message: "Cool", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in debugPrint("did dismiss alert") })
            alertViewController.addAction(dismissAction)
            self.present(alertViewController, animated: true) {
                debugPrint("did present alert")
            }
        }

        let mySecondRightAction = FlaneurNavigationBarAction(faceView: .imageToggle(UIImage(named: "Tiny Icon")!, UIImage(named: "sample-321-like")!)) { _ in
            let alertViewController = UIAlertController(title: "My 2nd Alert", message: "Cool", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in debugPrint("did dismiss alert") })
            alertViewController.addAction(dismissAction)
            self.present(alertViewController, animated: true) {
                debugPrint("did present alert")
            }
        }

        return [myFirstRightAction, mySecondRightAction]
    }

    func textRightAction() -> [FlaneurNavigationBarAction] {
        let myTextAction = FlaneurNavigationBarAction(faceView: .label("Done")) {
            let alertViewController = UIAlertController(title: "My text Alert", message: "Cool", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in debugPrint("did dismiss alert") })
            alertViewController.addAction(dismissAction)
            self.present(alertViewController, animated: true) {
                debugPrint("did present alert")
            }
        }

        return [myTextAction]
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func clearRightButtonsAction(_ sender: Any? = nil) {
        navigationBar.setRightActions([])
    }

    @IBAction func restoreRightButtonsAction(_ sender: Any? = nil) {
        navigationBar.setRightActions(imageRightActions())
    }

    @IBAction func showTextRightButtonAction(_ sender: Any? = nil) {
        navigationBar.setRightActions(textRightAction())
    }

    @IBAction func disableRightButtonsActions(_ sender: Any? = nil) {
        for button in navigationBar.rightButtons {
            button.isEnabled = false
        }
    }

    @IBAction func toggleLeftButtonAction(_ sender: Any? = nil) {
        if isDefaultLeftAction {
            navigationBar.setLeftAction(myLongerLeftAction)
        } else {
            navigationBar.setLeftAction(myDefaultLeftAction)
        }

        isDefaultLeftAction = !isDefaultLeftAction
    }
}
