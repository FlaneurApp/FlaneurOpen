//
//  FormDemoViewController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 28/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen


class FormDemoViewController: UIViewController {
    @IBOutlet weak var formView: FlaneurFormView!

    var firstResponderView: UIView?
    var didAppear = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        formView.configure(viewController: self)
        let nameFormElement = FlaneurFormElement(type: .textField, label: "Name") { view in
            self.firstResponderView = view
            if self.didAppear {
                self.firstResponderView?.becomeFirstResponder()
            }
        }
        formView.addFormElement(nameFormElement)

        let descriptionFormElement = FlaneurFormElement(type: .textArea, label: "Description")
        formView.addFormElement(descriptionFormElement)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        didAppear = true
        firstResponderView?.becomeFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
