//
//  MenuNavigationController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 30/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen

enum MenuOption: String {
    case legacyMenu = "Legacy Menu"
    case grayscaleDemo = "Grayscale Views"
    case segmentedCollectionView = "SegmentedCollectionView"
}

extension MenuOption {
    var cellDescriptor: TableViewCellDescriptor {
        return TableViewCellDescriptor(reuseIdentifier: "menuItem", configure: self.configureCell)
    }

    func configureCell(_ cell: MenuOptionCell) {
        cell.textLabel?.text = self.rawValue
    }
}

final class MenuOptionCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// The root menu of demo options.
class MenuNavigationController: UINavigationController {
    let optionsViewController: ItemsViewController<MenuOption> = {
        let menuOptionItems: [MenuOption] = [
            .legacyMenu,
            .grayscaleDemo,
            .segmentedCollectionView
        ]
        let result = ItemsViewController<MenuOption>(items: menuOptionItems, cellDescriptor: { $0.cellDescriptor })
        result.navigationItem.title = "Flaneur Open Demos"
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [ optionsViewController ]

        optionsViewController.didSelect = { menuOption in
            switch menuOption {
            case .legacyMenu:
                self.performSegue(withIdentifier: "legacyMenueSegue", sender: self)
            case .grayscaleDemo:
                self.pushViewController(GrayscalingViewController(), animated: true)
            case .segmentedCollectionView:
                self.pushViewController(SegmentedCollectionViewController(), animated: true)
            default:
                debugPrint("Unhandled menu option.")
            }
        }
    }
}
