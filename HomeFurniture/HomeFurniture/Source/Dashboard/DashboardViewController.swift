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
    
    private let furnitureCollectionViewCell = "FurnitureCollectionViewCell"
    private let furnitureCollectionViewCellIdentifier = "FurnitureCollectionViewCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initialzeDashboardViewController()
    }

    deinit {
        //Destroying and single instance here as it was created here
        CoreDataHelper.destroyInstance()
    }
    
    var furnitureManager: FurnitureManager {
        return FurnitureManager.shared
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension DashboardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let furnitureCount = furnitureManager.userFurniture?.furnitures?.count else {
            return 0
        }
        return furnitureCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: furnitureCollectionViewCellIdentifier, for: indexPath) as! FurnitureCollectionViewCell
        
        cell.data = furnitureManager.userFurniture?.furnitures?.object(at: indexPath.row) as? Furniture
        
        cell.cellWidthConstriant.constant = getCellWidth(collectionView)

        return cell
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

// MARK: - UICollectionViewDelegate
extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let furniture = furnitureManager.userFurniture?.furnitures?.object(at: indexPath.row) as? Furniture
        pushCreatFurnictureVC(actionType: .edit, furniture: furniture, animate: true)
    }
}

// MARK: - Button Actions
extension DashboardViewController {
    
    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        pushCreatFurnictureVC(actionType: .addNew, furniture: nil, animate: false)
    }
}

// MARK: - Private Methods
extension DashboardViewController {
    
    private func initialzeDashboardViewController() {
        initializeFlowLayout()
        registerCells()
    }
    
    private func initializeFlowLayout() {
        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        flowLayout.estimatedItemSize = CGSize(width: 350, height: 200)
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: furnitureCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: furnitureCollectionViewCellIdentifier)
    }
    
    func reloadData() {
        showOrHideMessageLabel()
        collectionView.reloadData()
    }
    
    private func showOrHideMessageLabel() {
        guard let count = furnitureManager.userFurniture?.furnitures?.count, count > 0 else {
            messagelabel.isHidden = false
            return
        }
        messagelabel.isHidden = true
    }
    
    private func pushCreatFurnictureVC(actionType: FurnictureDetailActionType, furniture: Furniture?, animate: Bool) {
        let createFurnitureVc = FurnictureDetailViewController(actionType: actionType, furniture: furniture)
        self.navigationController?.pushViewController(createFurnitureVc, animated: animate)
    }
}
