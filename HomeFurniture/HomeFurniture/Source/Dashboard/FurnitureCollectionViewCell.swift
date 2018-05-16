//
//  FurnitureCollectionViewCell.swift
//  HomeFurniture
//
//  Created by Shridhar on 16/05/18.
//

import UIKit

protocol FurnitureCollectionViewCellDelegate: class {
    func didTapOnFavouriteButton(sender: FurnitureCollectionViewCell, furniture: Furniture)
}

class FurnitureCollectionViewCell: UICollectionViewCell {

    public weak var delegate: FurnitureCollectionViewCellDelegate?
    
    @IBOutlet weak var cellWidthConstriant: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapOnFavouriteButton(_ sender: UIButton) {
        delegate?.didTapOnFavouriteButton(sender: self, furniture: data)
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
        favouriteButton.isSelected = data.favourite
        
        if let imageData = data.image {
            imageView.image = UIImage(data: imageData)
        }
    }
}
