//
//  FurnitureCollectionViewCell.swift
//  HomeFurniture
//
//  Created by Shridhar on 5/19/18.
//

import UIKit

class FurnitureCollectionViewCell: UICollectionViewCell {
    
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
        self.imageView.image = data.imageData?.image
    }
}
