//
//  UIView.swift
//  HomeFurniture
//
//  Created by Bhargavi Shamuk on 5/21/18.
//

import Foundation
import UIKit

extension UIView {
    func setBorderCornerRadius() {
        layer.borderWidth = 1 / UIScreen.main.scale
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 3
    }
}
