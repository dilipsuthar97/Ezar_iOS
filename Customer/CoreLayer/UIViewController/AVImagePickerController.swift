//
//  AVImagePickerController.swift
//  Business
//
//  Created by Volkoff on 28/04/22.
//

import UIKit


class AVImagePickerController: BaseViewController {
    
    var imagePickerController: UIImagePickerController!
    var imageHandler: ((UIImage) -> Void)?

    //MARK :-View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func imagePickerView(isPhotoOnly:Bool = false, allowsEditing: Bool = true) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = allowsEditing
        imagePickerController.mediaTypes = ["public.image"]
        
        if isPhotoOnly {
            self.openGallary()
        } else {
            let alert = UIAlertController(title: nil,
                                          message: nil,
                                          preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera",
                                          style: .default,
                                          handler: { _ in
                self.openCamera()
            }))
            alert.addAction(UIAlertAction(title: "Gallery",
                                          style: .default,
                                          handler: { _ in
                self.openGallary()
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel",
                                               style: .cancel,
                                               handler: nil))
            self.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning",
                                           message: "You don't have camera",
                                           preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            self.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.modalPresentationStyle = .fullScreen
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

//MARK: CustomImagePicker
extension AVImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.delay(0) {
            var originalImage = info[.originalImage]

            if self.imagePickerController.sourceType == .camera {
                if let image = info[.editedImage] {
                    originalImage = image
                    self.imageHandler!(image as! UIImage)
                }
            } else {
                if let image = info[.editedImage] {
                    originalImage = image
                }
            }
            
            self.imageHandler!(originalImage as! UIImage)
            self.dismiss(animated:true, completion: nil)
        }
    }
}
