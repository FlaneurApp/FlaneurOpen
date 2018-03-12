//
//  PhotoCollectionViewCell.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 27/10/2017.
//

import UIKit
import FlaneurImagePicker

class PhotoCollectionViewCell: UICollectionViewCell {
    var photoImageView: FlaneurImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    func didLoad() {
        let photoImageView = FlaneurImageView()
        self.photoImageView = photoImageView
        self.photoImageView.contentMode = .scaleAspectFill
        self.photoImageView.clipsToBounds = true
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(photoImageView)

        _ = LayoutBorderManager(item: photoImageView,
                                toItem: self,
                                top: 0.0,
                                left: 0.0,
                                bottom: 0.0,
                                right: 0.0)
    }

    func configureWith(imageDescription: FlaneurImageDescriptor) {
        photoImageView.setImage(with: imageDescription)
    }

    override func prepareForReuse() {
        photoImageView.prepareForReuse()
        super.prepareForReuse()
    }
}
