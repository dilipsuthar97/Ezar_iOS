//
//  CustomImagePickerController.swift
//  Thoab
//
//  Created by webwerks on 18/03/18.
//  Copyright © 2017 webwerks. All rights reserved.
//

import UIKit

protocol CustomPickerControlllerDelegate {
    func finishedWithSelectedImage(withImage: UIImage)
}

class CustomImagePickerController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imagePickerController : UIImagePickerController!
    var controller: UIViewController!
    var delegate: CustomPickerControlllerDelegate?
    
    func openGalery(withController: UIViewController ) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        controller = withController
        let alert = UIAlertController(title: TITLE.customer_choose_image.localized, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: TITLE.customer_camera.localized, style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: TITLE.customer_gallery.localized, style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: TITLE.cancel.localized, style: .cancel, handler: nil))
        
        withController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            imagePickerController.allowsEditing = true
            controller.present(imagePickerController, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: TITLE.customer_warning.localized, message: TITLE.customer_no_camera.localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: TITLE.ok.localized, style: .default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.allowsEditing = true
        controller.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.delay(0) {
            var originalImage = info[.originalImage]
            if let image = info[.editedImage] {
                originalImage = image
            }
            self.delegate?.finishedWithSelectedImage(withImage: originalImage as! UIImage)
            self.controller.dismiss(animated:true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        controller.dismiss(animated: true, completion: nil)
    }    
}
