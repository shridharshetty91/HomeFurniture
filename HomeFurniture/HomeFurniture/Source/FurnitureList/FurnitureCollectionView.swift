//
//  FurnitureCollectionView.swift
//  HomeFurniture
//
//  Created by Bhargavi Shamuk on 5/20/18.
//

import UIKit

protocol FurnitureCollectionViewDelegate: class {
    func furnitureCollectionView(_ collectionView: UICollectionView, didSelectFurniture furniture: Furniture)
}

class FurnitureCollectionView: UICollectionView {
    
    public weak var furnitureCollectionViewDelegate: FurnitureCollectionViewDelegate?
    
    private let furnitureCollectionViewCell = "FurnitureCollectionViewCell"
    private let furnitureCollectionViewCellIdentifier = "FurnitureCollectionViewCellIdentifier"
    
    var furnitures: [Furniture]? {
        didSet {
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initializeFurnitureCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var flowLayout: UICollectionViewFlowLayout {
        return self.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeFurnitureCollectionView()
    }
}

// MARK: - UICollectionViewDataSource
extension FurnitureCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let furnitures = furnitures else {
            return 0
        }
        return furnitures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: furnitureCollectionViewCellIdentifier, for: indexPath) as! FurnitureCollectionViewCell
        
        cell.data = furnitures![indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FurnitureCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let furniture = furnitures![indexPath.row]
        furnitureCollectionViewDelegate?.furnitureCollectionView(self, didSelectFurniture: furniture)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = getCellWidth(collectionView)
        return CGSize(width: width, height: width / 2 + 50)
    }
    
    private func getCellWidth(_ collectionView: UICollectionView) -> CGFloat {
        var numberOfItemsInARow = 1
        
        if collectionView.traitCollection.horizontalSizeClass == .regular ||
            UIDevice.current.orientation == .landscapeLeft ||
            UIDevice.current.orientation == .landscapeRight {
            numberOfItemsInARow = 2
        }
        let totalAvailableWidth = collectionView.frame.width -
            (CGFloat(numberOfItemsInARow - 1) * flowLayout.minimumInteritemSpacing) -
            (flowLayout.sectionInset.left + flowLayout.sectionInset.right)
        let width = totalAvailableWidth / CGFloat(numberOfItemsInARow)
        
        return width
    }
}

// MARK: - Private Methods
extension FurnitureCollectionView {
    private func initializeFurnitureCollectionView() {
        self.dataSource = self
        self.delegate = self
        
        initializeFlowLayout()
        registerCells()
    }
    
    private func initializeFlowLayout() {
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets.zero
    }
    
    private func registerCells() {
        self.register(UINib(nibName: furnitureCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: furnitureCollectionViewCellIdentifier)
    }
    
}

