//
//  DashboardViewController.swift
//  HomeFurniture
//
//  Created by Shridhar on 16/05/18.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var messagelabel: UILabel!
    
    private var furnitures: [Furniture]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public let FurnitureCollectionViewCell = "FurnitureCollectionViewCell"
    public let FurnitureCollectionViewCellIdentifier = "FurnitureCollectionViewCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initialzeDashboardViewController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
}

// MARK: - UICollectionViewDataSource
extension DashboardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let furnitures = self.furnitures {
            return furnitures.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FurnitureCollectionViewCellIdentifier, for: indexPath) as! FurnitureCollectionViewCell
        cell.delegate = self
        cell.data = furnitures![indexPath.item]
        
        var numberOfItemsInARow = 1
        
        if (collectionView.traitCollection.horizontalSizeClass == .regular) {
            numberOfItemsInARow = 2
        }
        let totalAvailableWidth = collectionView.frame.width -
            (CGFloat(numberOfItemsInARow - 1) * flowLayout.minimumInteritemSpacing) -
            (flowLayout.sectionInset.left + flowLayout.sectionInset.right)
        let width = totalAvailableWidth / CGFloat(numberOfItemsInARow)
        cell.cellWidthConstriant.constant = width

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentCreatFurnictureVC(furniture: furnitures?[indexPath.item])
    }
}

// MARK: - FurnitureCollectionViewCellDelegate
extension DashboardViewController: FurnitureCollectionViewCellDelegate {
    func didTapOnFavouriteButton(sender: FurnitureCollectionViewCell, furniture: Furniture) {
        furniture.favourite = !furniture.favourite
        let indexpath = IndexPath(item: furnitures!.index(of: furniture)!, section: 0)
        collectionView.reloadItems(at: [indexpath])
        getAppDelegate().saveContext()
    }
}
// MARK: - Button Actions
extension DashboardViewController {
    
    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        presentCreatFurnictureVC()
    }
}

// MARK: - Private Methods
extension DashboardViewController {
    
    private func initialzeDashboardViewController() {
        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        flowLayout.estimatedItemSize = CGSize(width: 350, height: 200)
        collectionView.register(UINib(nibName: FurnitureCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: FurnitureCollectionViewCellIdentifier)
    }
    
    private func fetchData() {
        do {
            furnitures = try getMainContext().fetch(Furniture.fetchRequest()) as? [Furniture]
            
            guard let furnitures = furnitures, furnitures.count > 0 else {
                messagelabel.isHidden = false
                return
            }
            messagelabel.isHidden = true
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private func presentCreatFurnictureVC(furniture: Furniture? = nil) {
        let createFurnitureVc = CreatFurnictureViewController(furniture: furniture)
        self.navigationController?.pushViewController(createFurnitureVc, animated: false)
    }
}
