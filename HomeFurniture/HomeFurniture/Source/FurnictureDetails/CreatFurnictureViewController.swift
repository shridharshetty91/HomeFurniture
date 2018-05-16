//
//  CreatFurnictureViewController.swift
//  HomeFurniture
//
//  Created by Shridhar on 16/05/18.
//

import UIKit
import CoreData

class CreatFurnictureViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    private var furniture: Furniture?
    private var creatingNew: Bool {
        return furniture == nil
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
    
    init(furniture: Furniture?) {
        super.init(nibName: "CreatFurnictureViewController", bundle: nil)
        
        self.furniture = furniture
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeCreatFurnictureViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        selectImage()
    }
}

// MARK: - Button Actions
extension CreatFurnictureViewController {
    @IBAction func didtapImage(_ sender: UITapGestureRecognizer) {
        selectImage()
    }
    
    @objc func didTapAddOrUpdateFurnicture() {
        
        guard let image = image,
            let imageData = UIImageJPEGRepresentation(image,
                                                      ImageCompressionRatio) else {
            showError(message: ChooseImage)
            return
        }
        
        guard let name = nameTextField.text, name.isEmpty == false else {
            showError(message: EnterName)
            return
        }
        
        
        if creatingNew {
            
            furniture = NSEntityDescription.insertNewObject(forEntityName: "Furniture",
                                                            into: getMainContext()) as? Furniture
            furniture?.createdDate = Date()
        }
        
        furniture?.updatedDate = Date()
        furniture?.image = imageData
        furniture?.name = name
        furniture?.details = detailTextView.text
        
        getAppDelegate().saveContext()
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CreatFurnictureViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let newImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        image = newImage
        picker.dismiss(animated: false, completion: nil)
    }
}

// MARK: - Private Methods
extension CreatFurnictureViewController {
    
    private func initializeCreatFurnictureViewController() {
        self.title = "Furniture"
        
        if let furniture = furniture {
            nameTextField.text = furniture.name
            detailTextView.text = furniture.details
            
            if let imageData = furniture.image {
                image = UIImage(data: imageData)
            }
            
        } else {
            selectImage()
        }
        
        setBorderAndCornerRadius(view: imageView)
        setBorderAndCornerRadius(view: detailTextView)
        
        setNavigationBarButtons()
    }
    
    func setNavigationBarButtons() {
        var addOrUpdate: UIBarButtonItem!
        if creatingNew {
            addOrUpdate = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(CreatFurnictureViewController.didTapAddOrUpdateFurnicture))
        } else {
            addOrUpdate = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(CreatFurnictureViewController.didTapAddOrUpdateFurnicture))
        }
        
        self.navigationItem.rightBarButtonItem = addOrUpdate
    }
    
    private func setBorderAndCornerRadius(view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 3
    }
    
    private func selectImage() {
        let imageOptionsAC = UIAlertController(title: AddFurniture,
                                               message: ChooseImageFrom,
                                               preferredStyle: .actionSheet)
        imageOptionsAC.addAction(UIAlertAction(title: CapturePhoto,
                                               style: .default,
                                               handler:
            { (action) in
                self.presentImagePicker(imageSource: .camera)
        }))
        
        imageOptionsAC.addAction(UIAlertAction(title: PhotoLibrary,
                                               style: .default,
                                               handler:
            { (action) in
                self.presentImagePicker(imageSource: .photoLibrary)
        }))
        
        imageOptionsAC.addAction(UIAlertAction(title: Cancel,
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
            showError(message: UnAvailable)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = imageSource
        self.present(picker, animated: true, completion: nil)
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: Error, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Ok, style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

