//
//  UIViewController.swift
//  HomeFurniture
//
//  Created by Bhargavi Shamuk on 5/21/18.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?,
                   positiveAction: String?, positiveHandler: (() -> Void)?,
                   negativeAction: String? = nil, negativeHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let positiveButton = positiveAction {
            let positiveAction = UIAlertAction(title: positiveButton, style: .default) { (action) in
                positiveHandler?()
            }
            alertController.addAction(positiveAction)
        }
        
        if let negativeButton = negativeAction {
            let negativeAction = UIAlertAction(title: negativeButton, style: UIAlertActionStyle.destructive, handler: { (action) in
                negativeHandler?()
            })
            alertController.addAction(negativeAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showImageOptions(sourceView: UIView, chooseFrom: @escaping (_ imageSource: UIImagePickerControllerSourceType) -> Void) {
        let imageOptionsAC = UIAlertController(title: nil,
                                               message: AlertConstants.chooseImageFrom,
                                               preferredStyle: .actionSheet)
        imageOptionsAC.addAction(UIAlertAction(title: AlertConstants.capturePhoto,
                                               style: .default,
                                               handler:
            { (action) in
                chooseFrom(.camera)
        }))
        
        imageOptionsAC.addAction(UIAlertAction(title: AlertConstants.photoLibrary,
                                               style: .default,
                                               handler:
            { (action) in
                chooseFrom(.photoLibrary)
        }))
        
        imageOptionsAC.addAction(UIAlertAction(title: AlertConstants.cancel,
                                               style: .cancel,
                                               handler: nil))
        if let popoverController = imageOptionsAC.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
        }
        self.present(imageOptionsAC, animated: true, completion: nil)
    }
}
