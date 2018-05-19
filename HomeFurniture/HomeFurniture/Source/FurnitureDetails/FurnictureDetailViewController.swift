//
//  FurnictureDetailViewController.swift
//  HomeFurniture
//
//  Created by Shridhar on 5/19/18.
//

import UIKit
import CoreData

enum FurnictureDetailActionType {
    case addNew
    case edit
    case invalid
}

class FurnictureDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var furniture: Furniture?
    private var actionType = FurnictureDetailActionType.invalid
    
    private var FurnictureDetailViewControllerNibName = "FurnictureDetailViewController"
    
    init(actionType: FurnictureDetailActionType, furniture: Furniture?) {
        super.init(nibName: FurnictureDetailViewControllerNibName, bundle: nil)
        
        self.actionType = actionType
        self.furniture = furniture
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeFurnictureDetailViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var image: UIImage? {
        didSet {
            guard let _ = image else {
                imageView.image = nil
                return
            }
            imageView.image = image
        }
    }
    
    var furnitureManager: FurnitureManager {
        return FurnitureManager.shared
    }
}

// MARK: - Button Actions
extension FurnictureDetailViewController {
    @IBAction func didtapImage(_ sender: UITapGestureRecognizer) {
        selectImage()
    }
    
    @objc func didTapOnAddOrUpdateButton() {
        
        validateAndUpdateFurniture()
    }
    
    @IBAction func didTapOnDeleteButtom(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: AlertConstants.deleteFurnitureAlert, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: AlertConstants.no, style: .cancel, handler: nil)
        alertController.addAction(noAction)
        
        let deletAction = UIAlertAction(title: AlertConstants.yes, style: UIAlertActionStyle.destructive, handler: { (action) in
            self.furnitureManager.deleteFurniture(furniture: self.furniture!)
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(deletAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension FurnictureDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let newImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        image = newImage
        picker.dismiss(animated: false, completion: nil)
    }
}

// MARK: - Private Methods
extension FurnictureDetailViewController {
    
    private func initializeFurnictureDetailViewController() {
        setData()
        initialzeNavigationBar()
        configureLayout()
    }
    
    private func setData() {
        if actionType == .edit {
            deleteButton.isHidden = false
            
            if let furniture = furniture {
                nameTextField.text = furniture.name
                detailTextView.text = furniture.details
                
                if let imageData = furniture.image {
                    image = UIImage(data: imageData)
                }
            }
        } else if actionType == .addNew {
            deleteButton.isHidden = true
            selectImage()
        }
    }
    
    private func initialzeNavigationBar() {
        self.title = AlertConstants.furnitureVCTitle
        
        var addOrUpdate: UIBarButtonItem!
        
        if actionType == .addNew {
            
            addOrUpdate = UIBarButtonItem(title: AlertConstants.addButtonTitle, style: .plain, target: self, action: #selector(FurnictureDetailViewController.didTapOnAddOrUpdateButton))
            
        } else if actionType == .edit {
            
            addOrUpdate = UIBarButtonItem(title: AlertConstants.updateButtonTitle, style: .plain, target: self, action: #selector(FurnictureDetailViewController.didTapOnAddOrUpdateButton))
        }
        
        self.navigationItem.rightBarButtonItem = addOrUpdate
    }
    
    private func configureLayout() {
        setBorderAndCornerRadius(view: imageView)
        setBorderAndCornerRadius(view: detailTextView)
    }
    
    private func setBorderAndCornerRadius(view: UIView) {
        view.layer.borderWidth = 1 / UIScreen.main.scale
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 3
    }
    
    private func validateAndUpdateFurniture() {
        guard let image = image,
            let imageData = UIImageJPEGRepresentation(image, AppConstants.imageCompressionRatio) else {
                showError(message:  AlertConstants.imageIsRequired)
                return
        }
        
        var name = nameTextField.text ?? ""
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard name.isEmpty == false else {
            showError(message: AlertConstants.enterName)
            return
        }
        
        if (actionType == .edit && furniture?.name != name) || actionType == .addNew {
            if furnitureManager.isFurnitureExists(furnitureWithName: name) {
                let alertController = UIAlertController(title: nil, message: AlertConstants.furnutureExists, preferredStyle: .alert)
                
                let noAction = UIAlertAction(title: AlertConstants.no, style: .cancel, handler: nil)
                alertController.addAction(noAction)
                
                let deletAction = UIAlertAction(title: AlertConstants.continueText, style: UIAlertActionStyle.destructive, handler: { (action) in
                    self.addOrUpdateFurniture(name: name, details: self.detailTextView.text, imageData:  imageData)
                })
                alertController.addAction(deletAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                addOrUpdateFurniture(name: name, details: detailTextView.text, imageData:  imageData)
            }
        } else {
            addOrUpdateFurniture(name: name, details: detailTextView.text, imageData:  imageData)
        }
        
    }
    
    func addOrUpdateFurniture(name: String, details: String?, imageData: Data) {
        if actionType == .addNew {
            furniture = furnitureManager.addFurniture(name: name, details: details, imageData: imageData)
        } else if actionType == .edit {
            furniture = furnitureManager.updateFurniture(furniture: furniture!, name: name, details: detailTextView.text, imageData: imageData)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func selectImage() {
        let imageOptionsAC = UIAlertController(title: nil,
                                               message: AlertConstants.chooseImageFrom,
                                               preferredStyle: .actionSheet)
        imageOptionsAC.addAction(UIAlertAction(title: AlertConstants.capturePhoto,
                                               style: .default,
                                               handler:
            { (action) in
                self.presentImagePicker(imageSource: .camera)
        }))
        
        imageOptionsAC.addAction(UIAlertAction(title: AlertConstants.photoLibrary,
                                               style: .default,
                                               handler:
            { (action) in
                self.presentImagePicker(imageSource: .photoLibrary)
        }))
        
        imageOptionsAC.addAction(UIAlertAction(title: AlertConstants.cancel,
                                               style: .cancel,
                                               handler: nil))
        if let popoverController = imageOptionsAC.popoverPresentationController {
            popoverController.sourceView = imageView
            popoverController.sourceRect = imageView.bounds
        }
        self.present(imageOptionsAC, animated: true, completion: nil)
    }
    
    private func presentImagePicker(imageSource: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(imageSource) else {
            showError(message: AlertConstants.featureUnAvailable)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = imageSource
        self.present(picker, animated: true, completion: nil)
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(title: AlertConstants.error, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertConstants.ok, style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

