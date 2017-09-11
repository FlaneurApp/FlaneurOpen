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

    override func viewDidLoad() {
        super.viewDidLoad()

        UILabel.appearance(whenContainedInInstancesOf: [FlaneurNavigationBar.self]).font = UIFont(name: "Futura-Medium", size: 16.0)

        let myLeftAction = FlaneurNavigationBarAction(image: UIImage(named: "sample-844-trumpet")!) { _ in
            self.navigationController?.popViewController(animated: true)
        }

        let myFirstRightAction = FlaneurNavigationBarAction(image: UIImage(named: "sample-986-ghost")!) { _ in
            let alertViewController = UIAlertController(title: "My 1st Alert", message: "Cool", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in debugPrint("did dismiss alert") })
            alertViewController.addAction(dismissAction)
            self.present(alertViewController, animated: true) {
                debugPrint("did present alert")
            }
        }

        let mySecondRightAction = FlaneurNavigationBarAction(image: UIImage(named: "Tiny Icon")!) { _ in
            let alertViewController = UIAlertController(title: "My 2nd Alert", message: "Cool", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in debugPrint("did dismiss alert") })
            alertViewController.addAction(dismissAction)
            self.present(alertViewController, animated: true) {
                debugPrint("did present alert")
            }
        }

        self.navigationBar.configure(title: "My Super Very Long Navigation Bar Title".uppercased(),
                                     leftAction: myLeftAction,
                                     rightActions: [myFirstRightAction, mySecondRightAction])
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
