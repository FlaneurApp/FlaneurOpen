//
//  CircleButton.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 13/02/2018.
//

import UIKit

public class CircleButton: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
//        clipsToBounds = true
//        imageView?.contentMode = .scaleAspectFill
//        imageView?.backgroundColor = .gray
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
//        debugPrint("smallerSide: \(smallerSide)")
//        imageView?.layer.cornerRadius = smallerSide / 2.0
        super.layoutSubviews()
    }

    var smallerSide: CGFloat {
        guard let imageView = imageView else { return 0.0 }
        return min(imageView.frame.size.height, imageView.frame.size.width)
    }
}
