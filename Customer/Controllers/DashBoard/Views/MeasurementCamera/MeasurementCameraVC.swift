//
//  MeasurementCameraVC.swift
//  EZAR
//
//  Created by abc on 17/08/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CoreMotion
import GTProgressBar

class MeasurementCameraVC: BaseViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var imgOverlay: UIImageView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var shapeLayer: UIView!
    @IBOutlet weak var progressBar: GTProgressBar!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var perfectView: UIView!
    @IBOutlet weak var perfectImageView: UIImageView!
    @IBOutlet weak var previewBtn: UIButton!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var btnTakePicture: UIButton!
    @IBOutlet weak var audioPlayBtn: UIButton!
    @IBOutlet weak var topBGView: UIView!
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    //  var previewLayer : AVCaptureVideoPreviewLayer?
    
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var captureDevice : AVCaptureDevice?
    let manager = CMMotionManager()
    var progressValue = 0.0
    var picker = UIImagePickerController()
    var alert = UIAlertController(title: TITLE.choose.localized + TITLE.image.localized, message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    var isCamraBtnTap = false
    var timer:Timer?
    var timeLeft = 60
    var isTakePictureBtnSelected = false
    var timerStop = false
    var isSideViewImage  = false
    var pressed = false
    var imageArray : [UIImage] = []
    var ispressedPreviewBtn = false
    var player: AVAudioPlayer?
    let screenSize:CGRect = UIScreen.main.bounds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.customer_scan_body.localized
        btnTakePicture.setTitle(TITLE.customer_start_msg.localized, for: .normal)
        player?.delegate = self
        if isCamraBtnTap == false{
            previewBtn.isHidden = false
        }else{
            previewBtn.isHidden = false
        }
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
            
            
            // Loop through all the capture devices on this phone
            for device in devices {
                // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaType.video)) {
                    // Finally check the position and confirm we've got the back camera
                    if(device.position == AVCaptureDevice.Position.front) {
                        
                        captureDevice = device
                        
                        if captureDevice != nil {
                            print("Capture device found")
                            beginSession()
                        }
                    }
                }
            }
            
        }
        
        
        //NEW
        
        //        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDuoCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera,AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.front)
        //        for device in (deviceDiscoverySession.devices){
        //            if(device.position == AVCaptureDevice.Position.front){
        //                do{
        //                    let input = try AVCaptureDeviceInput(device: device)
        //                    if(captureSession.canAddInput(input)){
        //                        captureSession.addInput(input);
        //
        //                        if(captureSession.canAddOutput(sessionOutput)){
        //                            captureSession.addOutput(sessionOutput);
        //                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        //                            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        //                            previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait;
        //                            self.view.layer.addSublayer(previewLayer);
        //                        }
        //                    }
        //                }
        //                catch{
        //                    print("exception!");
        //                }
        //            }
        //        }
        
        
        perfectView.isHidden = true
        perfectImageView.isHidden = true
        
        perfectView.layer.cornerRadius = 15
        perfectView.layer.masksToBounds = true
        
        timerLbl.layer.cornerRadius = 5
        timerLbl.layer.masksToBounds = true
        
        previewBtn.layer.cornerRadius = previewBtn.frame.height / 2.0
        previewBtn.layer.masksToBounds = true
        
        previewBtn.layer.borderColor = UIColor.lightGray.cgColor
        previewBtn.layer.borderWidth = 1
        
        manager.gyroUpdateInterval = 0.1
        manager.accelerometerUpdateInterval = 0.1
        
        manager.startGyroUpdates()
        manager.startAccelerometerUpdates()
        
        
        let queue = OperationQueue.main
        manager.startGyroUpdates(to: queue) {
            (data, error) in
            // ...
        }
        
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdates(to: OperationQueue.main) {
                [weak self] data, error in
                
                DispatchQueue.main.async {
                    
                    self?.progressBar.animateTo(progress: CGFloat((data!.gravity.y.round(to: 2)) * -1 ))
                    
                    let y = data?.gravity.y.round(to: 2)
                    let y1 = data?.gravity.y.round(to: 3)
                    if y == 0.99 || y == -0.99 || y1 == 0.999 || y1 == -0.999 {
                        
                        self?.textLbl.text = TITLE.customer_move_msg.localized//"PERFECT NOW MOVE BACK"
                        self?.perfectView.isHidden = false
                        self?.perfectImageView.isHidden = false
                        if self?.timeLeft == 0{
                            self?.timerLbl.text = "60"
                            
                            if self?.isTakePictureBtnSelected == true{
                                if self?.timerLbl.text == "0"{
                                    let image = UIImage(named: "mute")
                                    self?.audioPlayBtn.setImage(image, for: .normal)
                                    self?.player?.stop()
                                    self?.pressed = true
                                    
                                    if self?.isSideViewImage == true{
                                        
                                        self?.imgOverlay.image = UIImage(named: "1")
                                        self?.timeLeft = 60
                                        
                                    }else{
                                        self?.timeLeft = 30
                                        self?.imgOverlay.image = UIImage(named: "2")
                                    }
                                    
                                }else if self?.timerLbl.text == "30"{
                                    
                                    self?.timeLeft = 30
                                    self?.imgOverlay.image = UIImage(named: "2")
                                    
                                    
                                }else{
                                    
                                    self?.timeLeft = 60
                                    self?.imgOverlay.image = UIImage(named: "1")
                                }
                            }else{
                                
                                self?.timeLeft = 60
                                self?.imgOverlay.image = UIImage(named: "1")
                            }
                        }else{
                            
                            if self?.timerLbl.text == "0"{
                                self?.timerLbl.text = "60"
                                
                            }else{
                                
                                self?.timerLbl.isHidden = false
                            }
                            
                        }
                        
                    }else{
                        
                        let image = UIImage(named: "mute")
                        self?.audioPlayBtn.setImage(image, for: .normal)
                        self?.player?.pause()
                        self?.pressed = true
                        
                        
                        self?.isTakePictureBtnSelected = false
                        self?.perfectView.isHidden = true
                        self?.perfectImageView.isHidden = true
                        self?.textLbl.text = TITLE.customer_upright_msg.localized//"PLACE YOUR DEVICE UPRIGHT"
                        self?.timerLbl.isHidden = false
                        self?.timer?.invalidate()
                        self?.timer = nil
                        self?.timerLbl.text = ""
                        self?.timerStop = true
                        if self?.timerLbl.text == "0"{
                            if self?.isSideViewImage == false{
                                self?.timerLbl.text = "60"
                            }else{
                                self?.timerLbl.text = "30"
                            }
                        }else{
                            
                            if self?.imgOverlay.image == UIImage(named: "2"){
                                self?.timerLbl.text = "30"
                            }else{
                                self?.timerLbl.text = "60"
                            }
                            
                        }
                        
                    }
                }
            }
        }
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc func appMovedToBackground() {
        player?.stop()
        let image = UIImage(named: "mute")
        audioPlayBtn.setImage(image, for: .normal)
        pressed = true
        timer?.invalidate()
        timer = nil
        
    }
    
    @objc func appMovedToForeground() {
        if imgOverlay.image == UIImage(named: "2"){
            isSideViewImage = true
            timeLeft = 30
            timerLbl.text = "30"
            isTakePictureBtnSelected = false
        }else{
            isSideViewImage = false
            timeLeft = 60
            timerLbl.text = "60"
            isTakePictureBtnSelected = false
        }
    }
    
    @objc func onTimerFires() {
        if self.timeLeft != 0{
            self.timeLeft = self.timeLeft - 1
            self.timerLbl.text = "\(self.timeLeft)"
        }
        
        if timeLeft == 0 {
            timer?.invalidate()
            timer = nil
            
            let image = UIImage(named: "mute")
            audioPlayBtn.setImage(image, for: .normal)
            player?.stop()
            self.pressed = true
            
            timerLbl.text = "60"
            isCamraBtnTap = true
            self.imgOverlay.image = UIImage(named: "1")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if self.ispressedPreviewBtn == false{
                    if self.imageArray.count >= 2{
                        let vc = PreviewViewController.loadFromNib()
                        vc.imageArray = self.imageArray
                        vc.deleagate = self
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
            if isCamraBtnTap == false{
                previewBtn.isHidden = true
                timerLbl.isHidden = true
            }else{
                previewBtn.isHidden = false
                timerLbl.isHidden = true
            }
            self.saveToCamera()
            isTakePictureBtnSelected = false
        }else if timeLeft == 30{
            isTakePictureBtnSelected = false
            self.timeLeft = 30
            self.timerLbl.text = "30"
            self.imgOverlay.image = UIImage(named: "2")
            
            isCamraBtnTap = true
            if isCamraBtnTap == false{
                previewBtn.isHidden = true
                timerLbl.isHidden = true
            }else{
                previewBtn.isHidden = false
                timerLbl.isHidden = true
            }
            self.saveToCamera()
        }
    }
    
    @IBAction func actionAudioBtn(_ sender: AnyObject) {
        
        if !self.pressed {
            let image = UIImage(named: "mute")
            audioPlayBtn.setImage(image, for: .normal)
            self.pressed = true
            player?.stop()
            
        } else {
            let image = UIImage(named: "volume")
            audioPlayBtn.setImage(image, for: .normal)
            playSound()
            self.pressed = false
        }
        
    }
    @IBAction func actionTakeCapture(_ sender: AnyObject) {
        
        if isTakePictureBtnSelected == false{
            
            if  self.progressBar.progress == 1.0 {
                
                if timeLeft <= 30{
                    player?.play()
                }else{
                    self.playSound()
                }
            }else{
                self.playSound()
            }
            let image = UIImage(named: "volume")
            audioPlayBtn.setImage(image, for: .normal)
            self.pressed = false
            player?.delegate = self
            
            isTakePictureBtnSelected = true
            timer?.invalidate()
            // timer = nil
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
            
            if imgOverlay.image == UIImage(named: "2"){
                isSideViewImage = true
                self.timeLeft = 30
            }else{
                isSideViewImage = false
                self.timeLeft = 60
            }
        }
    }
    
    @IBAction func actionCameraCapture(_ sender: AnyObject) {
        
        print("Camera button pressed")
        
        isCamraBtnTap = true
        if isCamraBtnTap == false{
            previewBtn.isHidden = true
        }else{
            previewBtn.isHidden = false
        }
        
        saveToCamera()
    }
    
    
    @IBAction func actionPreviewBtn(_ sender: AnyObject) {
        if imageArray.count >= 2{
            ispressedPreviewBtn = true
            player?.stop()
            let image = UIImage(named: "mute")
            audioPlayBtn.setImage(image, for: .normal)
            self.pressed = true
        }
        if imageArray.count >= 2{
            let vc = PreviewViewController.loadFromNib()
            vc.imageArray = self.imageArray
            vc.deleagate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK: functions
    func playSound() {
        
        let url = Bundle.main.url(forResource:"finalRecording", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func beginSession() {
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        //  guard
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        //  previewLayer.videoGravity = .resizeAspect
        // previewLayer.videoGravity = .resizeAspectFill
        // let bounds:CGRect = self.view.layer.bounds
        // previewLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        previewLayer.frame = CGRect(x: 0, y: 0, width:screenSize.width, height: screenSize.height - 50)//self.view.layer.frame
        self.view.layer.addSublayer(previewLayer)
        
        //  self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //  self.previewLayer.connection?.videoOrientation = .portrait
        
        
        imgOverlay.frame = self.shapeLayer.frame
        
        if self.isTakePictureBtnSelected == true{
            if timerLbl.text == "0"{
                
                imgOverlay.image = UIImage(named: "2")
            }else{
                imgOverlay.image = UIImage(named: "1")
            }
        }else{
            imgOverlay.image = UIImage(named: "1")
        }
        //  self.view.layer.addSublayer(previewLayer)
        self.view.bringSubviewToFront(imgOverlay)
        self.view.bringSubviewToFront(btnCapture)
        self.view.bringSubviewToFront(progressBar)
        self.view.bringSubviewToFront(progressView)
        self.view.bringSubviewToFront(textLbl)
        self.view.bringSubviewToFront(perfectImageView)
        self.view.bringSubviewToFront(perfectView)
        self.view.bringSubviewToFront(previewBtn)
        self.view.bringSubviewToFront(timerLbl)
        self.view.bringSubviewToFront(btnTakePicture)
        self.view.bringSubviewToFront(audioPlayBtn)
        self.view.bringSubviewToFront(topBGView)
        
        
        captureSession.startRunning()
        print("Capture session running")
        
        
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func drawCirclesOnImage(fromImage: UIImage? = nil, targetSize: CGSize? = CGSize.zero) -> UIImage? {
        
        if fromImage == nil && targetSize == CGSize.zero {
            return nil
        }
        
        var tmpimg: UIImage?
        
        if targetSize == CGSize.zero {
            
            tmpimg = fromImage
            
        } else {
            
            tmpimg = getImageWithColor(color: UIColor.clear, size: targetSize!)
            
        }
        
        guard let img = tmpimg else {
            return nil
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tmpimg
    }
    
    func saveToCamera() {
        
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                
                if let buffer = CMSampleBuffer{
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) {
                        
                        if let cameraImage = UIImage(data: imageData) {
                            
                            if let nImage = self.drawCirclesOnImage(fromImage: cameraImage, targetSize: CGSize.zero) {
                                
                                self.previewBtn.contentMode = UIView.ContentMode.scaleAspectFit
                                
                                self.previewBtn.setBackgroundImage(nImage, for: .normal)
                                //                                    if  let image = cameraImage.resizedTo1MB(compressValue: 0.75){
                                self.imageArray.append(cameraImage)
                                //}
                                
                                //UIImageWriteToSavedPhotosAlbum(nImage, nil, nil, nil)
                            }
                        }
                    }
                }
            })
        }
    }
}

//MARK:-AVAudioPlayerDelegate
extension MeasurementCameraVC : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true{
            let image = UIImage(named: "mute")
            audioPlayBtn.setImage(image, for: .normal)
            self.pressed = true
        }
    }
}

//MARK:-AVAudioPlayerDelegate
extension MeasurementCameraVC : PreviewViewControllerDelegate{
    func removeImages(isfromRetake: Bool) {
        if isfromRetake == true{
            imageArray.removeAll()
            self.previewBtn.setBackgroundImage(UIImage(named: "placeholder1"), for: .normal)
            self.ispressedPreviewBtn = false
        }
    }
}


