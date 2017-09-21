//
//  DemoCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 21/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class DemoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFill
    }

    override var isSelected: Bool {
        didSet {
            updateBackgroundColorFromSelection()
        }
    }

    func updateBackgroundColorFromSelection() {
        self.backgroundColor = (isSelected ? .red : .blue)
    }
}
