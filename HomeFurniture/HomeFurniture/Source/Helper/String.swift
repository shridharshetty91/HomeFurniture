//
//  String+Extension.swift
//  HomeFurniture
//
//  Created by Bhargavi Shamuk on 5/21/18.
//

import Foundation

extension String {
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
