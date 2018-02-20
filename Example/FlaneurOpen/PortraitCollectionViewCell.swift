//
//  PortraitCollectionViewCell.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 25/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class PortraitCollectionViewCell: UICollectionViewCell {
    let portraitImageView = UIImageView()
    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(portraitImageView)
        portraitImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            portraitImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            portraitImageView.topAnchor.constraint(equalTo: self.topAnchor),
            portraitImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            portraitImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            debugPrint("New state: ", isSelected)
            backgroundColor = isSelected ? .yellow : .gray
        }
    }
}
