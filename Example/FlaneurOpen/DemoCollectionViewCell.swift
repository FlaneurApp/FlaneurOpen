//
//  DemoCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 21/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen

class DemoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        didLoad()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        _ = LayoutBorderManager(item: imageView,
                                toItem: self,
                                top: 0,
                                left: 0,
                                bottom: 0,
                                right: 0)

        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        self.addSubview(label)
        _ = LayoutBorderManager(item: label,
                                toItem: self,
                                top: 0,
                                left: 0,
                                bottom: 0,
                                right: 0)

        didLoad()
    }

    func didLoad() {
        self.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFill
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
