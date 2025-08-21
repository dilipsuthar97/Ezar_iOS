//
//  PreviewViewController.swift
//  EZAR
//
//  Created by abc on 17/08/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit
import iOSPhotoEditor

protocol PreviewViewControllerDelegate{
    func removeImages(isfromRetake : Bool)
}

class PreviewViewController: BaseViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var collectionViewPreview: UICollectionView!
    var imageArray : [UIImage] = []
    var currentCount = 0
    var deleagate : PreviewViewControllerDelegate!
    let viewModel :TakeMeasurementViewModel = TakeMeasurementViewModel()
    var selectedIndex : Int?
    

    var name = ""
    var height = ""
    var images : [MultipartFileJPEG] = []
    var editPic = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarHidden(hide: false)
        setBackButton()
        navigationItem.title = TITLE.customer_preview_photo.localized

        self.confirmButton.setTitle(TITLE.customer_confirm_photo.localized, for: .normal)
        self.retakeButton.setTitle(TITLE.customer_retake_photo.localized, for: .normal)
        
        collectionViewPreview.register(UINib(nibName: "PreViewImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PreViewImageCollectionViewCell")
    }
    
    override func onClickLeftButton(button: UIButton) {
        self.deleagate.removeImages(isfromRetake: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishBtnAction(_ sender: Any) {
        let alert = UIAlertController(title: TITLE.customer_confirm.localized, message: TITLE.customer_confirm_msg.localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: TITLE.yes.localized, style: UIAlertAction.Style.default, handler:{ action in
            
        
            let profile = Profile.loadProfile()
            self.viewModel.customer_id = profile?.id ?? 0
            self.viewModel.title = COMMON_SETTING.name
            self.viewModel.bodyHeight = COMMON_SETTING.bodyHeight
            self.viewModel.bodyWeight = COMMON_SETTING.bodyWeight
            
//            if self.editPic == false{
//                for image in self.imageArray {
//                    if let image = image.resizedTo1MB(compressValue: 0.5){//resized(withPercentage: 0.5){
//                        self.images.append(MultipartFileJPEG(data: (image.jpeg!), name: "body_images[]"))
//                    }
//                }
//            }else{
//                self.editPic = false
//                for image in self.imageArray {
//                    if let image = image.resizedTo1MB(compressValue: 0.7){//resized(withPercentage: 0.7){
//                        self.images.append(MultipartFileJPEG(data: (image.jpeg!), name: "body_images[]"))
//                    }
//                }
//            }
            for image in self.imageArray {
                //                if self.editPic == false{
                //                    if let image = image.resizedTo1MB(compressValue: 0.5){//resized(withPercentage: 0.5){
                //                        self.images.append(MultipartFileJPEG(data: (image.jpeg!), name: "body_images[]"))
                //                    }
                //                }else{
                //                    self.editPic = false
                //                    if let image = image.resizedTo1MB(compressValue: 0.0){//resized(withPercentage: 0.7){
                //                        self.images.append(MultipartFileJPEG(data: (image.jpeg!), name: "body_images[]"))
                //                    }
                //                }
                
                self.images.append(MultipartFileJPEG(data: (image.jpeg!), name: "body_images[]"))
                
            }
            
    
            if self.images.count > 0{
                self.viewModel.bodyImage = self.images
            }else{
                self.viewModel.bodyImage  = []
            }
            
            if COMMON_SETTING.measurement_id == ""{
                self.viewModel.saveMeasurementMultipart {
                    self.viewModel.updateMeasurementForCartProductNew {
                        
                        self.navigationController?.backToViewController(viewController: ShoppingBagVC.self)
                    }
                }
            } else {
                self.viewModel.measurementID = COMMON_SETTING.measurement_id
                self.viewModel.saveMeasurementMultipart {
                    self.navigationController?.backToViewController(viewController: MeasurementVC.self)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: TITLE.no.localized, style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func retakeBtnAction(_ sender: Any) {
        showPopup(title: TITLE.customer_confirm.localized, messag: TITLE.customer_retake_msg.localized)
    }
    
    func showPopup(title : String ,messag : String){
        let alert = UIAlertController(title: title, message: messag, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: TITLE.yes.localized, style: UIAlertAction.Style.default, handler:{ action in
            self.deleagate.removeImages(isfromRetake: true)
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: TITLE.no.localized, style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
//MARK:UICollectionViewDataSource
extension PreviewViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreViewImageCollectionViewCell", for: indexPath) as! PreViewImageCollectionViewCell
        cell.imgView.image = self.imageArray[indexPath.row]
       // cell.image = self.imageArray[indexPath.row]
        cell.imgView.image = self.imageResize(self.imageArray[indexPath.row])
        
       // cell.imgView.image = self.imageArray[indexPath.row].resizedTo1MB(compressValue: 0.5)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
       // let cell = collectionView.cellForItem(at: indexPath)as! PreViewImageCollectionViewCell
         self.selectedIndex = indexPath.row
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        photoEditor.image =  self.imageArray[indexPath.row]
        
        photoEditor.hiddenControls = [.text, .share ,.sticker,.save]
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.currentContext //or .overFullScreen for transparency
        
        self.present(photoEditor, animated: true, completion: nil)
    }
    func imageResize (_ image:UIImage)-> UIImage{

        let size = CGSize(width: collectionViewPreview.frame.size.width, height:collectionViewPreview.frame.size.height)
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}

//MARK:UICollectionViewDelegateFlowLayout
extension PreviewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = collectionViewPreview.frame.size.width
        let height : CGFloat = collectionViewPreview.frame.size.height
        
//        let width : CGFloat = self.view.frame.size.width - 10
//        let height : CGFloat = collectionViewPreview.frame.size.height
        
        return CGSize(width: width, height: height)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Used for vertical cell spacing
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    }
}

//MARK:PhotoEditorDelegate
extension PreviewViewController: PhotoEditorDelegate {
    
    func doneEditing(image: UIImage) {
        editPic = true
       // self.imageArray.append(image)
        self.imageArray[self.selectedIndex ?? 0] = image
        self.collectionViewPreview.reloadData()
    }
    
    func canceledEditing() {
        print("Canceled")
    }
}
    
