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

struct FurnictureDetailVCInputs {
    var furnitureManager: FurnitureManager!
    var furniture: Furniture?
    var actionType = FurnictureDetailActionType.invalid
    
    fileprivate var imageChanged = false
    fileprivate var image: UIImage?
}

class FurnictureDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    private var addOrUpdate: UIBarButtonItem?
    
    private var inputs: FurnictureDetailVCInputs!
    private var FurnictureDetailViewControllerNibName = "FurnictureDetailViewController"
    
    init(inputs: FurnictureDetailVCInputs) {
        super.init(nibName: FurnictureDetailViewControllerNibName, bundle: nil)
        
        self.inputs = inputs
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeFurnictureDetailViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterNotifications()
    }
}

// MARK: - Button Actions
extension FurnictureDetailViewController {
    @IBAction func didtapImage(_ sender: UITapGestureRecognizer) {
        selectImage()
    }
    
    @objc func didTapOnAddOrUpdateButton() {
        
        addOrUpdateFurniture()
    }
    
    @IBAction func didTapOnDeleteButtom(_ sender: UIButton) {
        showAlert(title: nil, message: AlertConstants.deleteFurnitureAlert, positiveAction: AlertConstants.no, positiveHandler: nil, negativeAction: AlertConstants.yes, negativeHandler: { () in
            self.inputs.furnitureManager.deleteFurniture(furniture: self.inputs.furniture!)
            self.navigationController?.popViewController(animated: true)
        })
    }
}

// MARK: - UIImagePickerControllerDelegate
extension FurnictureDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let newImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        
        inputs.imageChanged = true
        setImage(image: newImage)
        picker.dismiss(animated: false, completion: nil)
    }
}

//MARK: - UITextViewDelegate
extension FurnictureDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        validateInputs()
    }
}

// MARK: - Private Methods
extension FurnictureDetailViewController {
    
    private func initializeFurnictureDetailViewController() {
        setData()
        initialzeNavigationBar()
        configureLayout()
        validateInputs()
    }
    
    private func setData() {
        if self.inputs.actionType == .edit {
            deleteButton.isHidden = false
            
            guard let furniture = self.inputs.furniture else {
                return
            }
            
            nameTextField.text = furniture.name
            detailTextView.text = furniture.details
            setImage(image: furniture.imageData?.image)
        } else {
            deleteButton.isHidden = true
        }
    }
    
    private func initialzeNavigationBar() {
        self.title = AlertConstants.furnitureVCTitle
        
        if self.inputs.actionType == .addNew {
            addOrUpdate = UIBarButtonItem(title: AlertConstants.addButtonTitle, style: .plain, target: self, action: #selector(FurnictureDetailViewController.didTapOnAddOrUpdateButton))
            
        } else {
            addOrUpdate = UIBarButtonItem(title: AlertConstants.updateButtonTitle, style: .plain, target: self, action: #selector(FurnictureDetailViewController.didTapOnAddOrUpdateButton))
        }
        
        self.navigationItem.rightBarButtonItem = addOrUpdate
    }
    
    private func configureLayout() {
        imageView.setBorderCornerRadius()
        detailTextView.setBorderCornerRadius()
    }
    
    func setImage(image: UIImage?) {
        inputs.image = image
        imageView.image = image
        validateInputs()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChangeText(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nameTextField)
    }
    
    private func deregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldDidChangeText(notification: Notification) {
        validateInputs()
    }
    
    private func getInputs() -> FurnitureInput {
        var inputs = FurnitureInput()
        inputs.imageData = self.inputs.image?.imageData
        inputs.name = nameTextField.text?.trim
        inputs.details = detailTextView.text
        return inputs
    }
    
    private func validateInputs() {
        let inputs = getInputs()
        guard self.inputs.furnitureManager.validate(input: inputs) else {
            addOrUpdate?.isEnabled = false
            return
        }
        
        if self.inputs.actionType == .addNew {
            addOrUpdate?.isEnabled = true
        } else {
            addOrUpdate?.isEnabled = self.inputs.furnitureManager.hasChanges(furniture: self.inputs.furniture!, input: inputs) || self.inputs.imageChanged
        }
    }
    
    private func addOrUpdateFurniture() {
        let input = getInputs()
        if self.inputs.actionType == .addNew {
            self.inputs.furniture = self.inputs.furnitureManager.addFurniture(input: input)
        } else if self.inputs.actionType == .edit {
            self.inputs.furniture = self.inputs.furnitureManager.updateFurniture(furniture: self.inputs.furniture!, input: input)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func selectImage() {
        showImageOptions(sourceView: imageView) { (sourceType) in
            self.presentImagePicker(imageSource: sourceType)
        }
    }
    
    private func presentImagePicker(imageSource: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(imageSource) else {
            showAlert(title: AlertConstants.error, message: AlertConstants.featureUnAvailable, positiveAction: AlertConstants.ok, positiveHandler: nil)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = imageSource
        self.present(picker, animated: true, completion: nil)
    }
}

