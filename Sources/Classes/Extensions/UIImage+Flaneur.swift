//
//  UIImage+Flaneur.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 30/01/2018.
//

import Foundation

public extension UIImage {
    /// Creates and returns a new image object with a grayscale filter applied.
    ///
    /// The code source for this implementation comes from
    /// [this Stack Overflow's answer](https://stackoverflow.com/a/41646252/455016).
    ///
    /// - Returns: A new image object with a grayscale filter applied.
    func withGrayscaleFilter() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let imageRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("No context available")
        }

        // Draw a white background
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        context.fill(imageRect)

        // optional: increase contrast with colorDodge before applying luminosity
        // (my images were too dark when using just luminosity - you may not need this)
        draw(in: imageRect, blendMode: CGBlendMode.colorDodge, alpha: 0.7)

        // Draw the luminosity on top of the white background to get grayscale of original image
        draw(in: imageRect, blendMode: CGBlendMode.luminosity, alpha: 0.90)

        // optional: re-apply alpha if your image has transparency - based on user1978534's answer (I haven't tested this as I didn't have transparency - I just know this would be the the syntax)
        // self.draw(in: imageRect, blendMode: CGBlendMode.destinationIn, alpha: 1.0)

        let grayscaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return grayscaleImage
    }
}

