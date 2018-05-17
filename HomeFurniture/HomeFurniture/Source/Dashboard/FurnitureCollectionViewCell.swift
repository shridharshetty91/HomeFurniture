//
//  FurnitureCollectionViewCell.swift
//  HomeFurniture
//
//  Created by Shridhar on 16/05/18.
//

import UIKit

class FurnitureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellWidthConstriant: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var data: Furniture! {
        didSet {
            dataUpdated()
        }
    }
    
    private func dataUpdated() {
        guard let data = data else { return }
        
        nameLabel.text = data.name
        descriptionLabel.text = data.details
        
        if let imageData = data.image {
            imageView.image = UIImage(data: imageData)
        }
    }
}
