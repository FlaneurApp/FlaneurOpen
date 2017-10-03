//
//  SpinnerCell.swift
//  FlaneurImagePickerController
//
//  Created by Frenchapp on 01/08/2017.
//  Copyright © 2017 Frenchapp. All rights reserved.
//

import UIKit

final class SpinnerCell: UICollectionViewCell {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.contentView.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = contentView.center
    }
    
}
