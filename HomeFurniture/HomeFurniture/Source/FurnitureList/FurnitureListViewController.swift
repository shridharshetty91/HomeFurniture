//
//  FurnictureListViewController.swift
//  HomeFurniture
//
//  Created by Shridhar on 5/19/18.
//

import UIKit
import CoreData

class FurnitureListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: FurnitureCollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var messagelabel: UILabel!
    
    
    private var furnitureManager: FurnitureManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialzeFurnictureListViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.flowLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.flowLayout.invalidateLayout()
    }
}

// MARK: - Button Actions
extension FurnitureListViewController {
    
    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        pushCreatFurnictureVC(actionType: .addNew, furniture: nil)
    }
}

//MARK: - FurnitureCollectionViewDelegate
extension FurnitureListViewController: FurnitureCollectionViewDelegate {
    func furnitureCollectionView(_ collectionView: UICollectionView, didSelectFurniture furniture: Furniture) {
        pushCreatFurnictureVC(actionType: .edit, furniture: furniture)
    }
}

// MARK: - Private Methods
extension FurnitureListViewController {
    
    private func initialzeFurnictureListViewController() {
        self.automaticallyAdjustsScrollViewInsets = false
        collectionView.furnitureCollectionViewDelegate = self
        
        furnitureManager = FurnitureManager()
        reloadData()
    }
    
    func reloadData() {
        showOrHideMessageLabel()
        collectionView.furnitures = furnitureManager.userFurniture?.furnitures?.array as? [Furniture]
    }
    
    private func showOrHideMessageLabel() {
        guard let count = furnitureManager.userFurniture?.furnitures?.count, count > 0 else {
            messagelabel.isHidden = false
            return
        }
        messagelabel.isHidden = true
    }
    
    private func pushCreatFurnictureVC(actionType: FurnictureDetailActionType, furniture: Furniture?) {
        var inputs = FurnictureDetailVCInputs()
        inputs.actionType = actionType
        inputs.furniture = furniture
        inputs.furnitureManager = furnitureManager
        let furnitureDetailsVc = FurnictureDetailViewController(inputs: inputs)
        self.navigationController?.pushViewController(furnitureDetailsVc, animated: true)
    }
}
