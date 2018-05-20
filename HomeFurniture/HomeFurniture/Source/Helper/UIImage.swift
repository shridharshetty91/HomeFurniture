//
//  UIImage+Extension.swift
//  HomeFurniture
//
//  Created by Bhargavi Shamuk on 5/20/18.
//

import Foundation
import UIKit

extension UIImage {
    
    var imageData: Data? {
        return UIImageJPEGRepresentation(self, AppConstants.imageCompressionRatio)
    }
    
}

extension Data {
    var image: UIImage? {
         return UIImage(data: self)
    }
}
