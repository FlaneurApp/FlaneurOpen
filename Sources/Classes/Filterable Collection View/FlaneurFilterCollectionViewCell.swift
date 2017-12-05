//
//  FlaneurFilterCollectionViewCell.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 12/09/2017.
//
//

import UIKit

fileprivate let padding: CGFloat = 6.0
fileprivate let rightIconImageViewSize: CGFloat = 8.0
fileprivate let filterNameLabelToRightIconSpace: CGFloat = 12.0

public class FlaneurFilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var rightIconImageView: UIImageView!

    var rightIconImage: UIImage? = nil {
        didSet {
            if let image = rightIconImage {
                rightIconImageView.image = image.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    var nbDisplays: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    /// Common init code.
    func didLoad() {
        let tmpLabel = UILabel()
        self.filterNameLabel = tmpLabel

        let tmpImageView = UIImageView()
        tmpImageView.contentMode = .scaleAspectFit
        if let image = rightIconImage {
            tmpImageView.image = image.withRenderingMode(.alwaysTemplate)
        }
        self.rightIconImageView = tmpImageView
        self.rightIconImageView.tintColor = .white

        // Colors
        backgroundColor = UIColor(white: (39.0 / 255.0), alpha: 1.0)
        filterNameLabel.textColor = .white

        // Position the title UILabel
        self.addSubview(filterNameLabel)
        self.addSubview(rightIconImageView)

        filterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        rightIconImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: filterNameLabel,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: padding).isActive = true
        NSLayoutConstraint(item: filterNameLabel,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true

        NSLayoutConstraint(item: rightIconImageView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -padding).isActive = true
        NSLayoutConstraint(item: rightIconImageView,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        NSLayoutConstraint(item: rightIconImageView,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: rightIconImageViewSize).isActive = true
        NSLayoutConstraint(item: rightIconImageView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: rightIconImageViewSize).isActive = true
    }

    func recommendedWidthForCell() -> CGFloat {
        return filterNameLabel.intrinsicContentSize.width + 2.0 * padding + rightIconImageViewSize + filterNameLabelToRightIconSpace
    }
}
