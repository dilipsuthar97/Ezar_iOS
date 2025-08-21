//
//  ScanBodyMeasurementVC.swift
//  EZAR
//
//  Created by abc on 13/07/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit
import STPopup
import SDWebImage
import AVFoundation
import AVKit

class ScanBodyMeasurementVC: BaseViewController ,AVPlayerViewControllerDelegate {

    var netteloWrapper: NEPhotoTakingWrapper? = nil

    @IBOutlet weak var skipButton: ActionButton!
    @IBOutlet weak var termAndConditionButton: ActionButton!
    @IBOutlet weak var playButton: ActionButton!
    @IBOutlet weak var checkBoxButton: ActionButton!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var videoView: UIView!
    
    var getSelectedImageName : String  = ""
    var videoURL : String = ""
    let viewModel : ScanBodyViewModel = ScanBodyViewModel()
    let mViewModel: TakeMeasurementViewModel = TakeMeasurementViewModel()
    var pressed = false
    var player: AVPlayer?
    var isFromIntro = false
    
    var netteloOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getApicall()
        
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        player?.pause()
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.customer_scan_body.localized
        setLeftButton()

        if isFromIntro {
            skipButton.isHidden = true
            termAndConditionButton.isHidden = true
            checkBoxButton.isHidden = true
            underlineView.isHidden = true
        }
        
        self.termAndConditionButton.setTitle(TITLE.customer_termsAndCondition.localized, for: .normal)
        self.skipButton.setTitle(TITLE.SKIP.localized.uppercased(), for: .normal)
        
        if ScanBodyViewModel.getTermsConditionsSkipOption() {
            skipButton.isUserInteractionEnabled = true
        } else {
            skipButton.isUserInteractionEnabled = false
        }
        
        self.playButton.touchUp = { button in
            self.playButtonClicked()
        }
        
        self.checkBoxButton.touchUp = { button in
            if !self.pressed {
                let image = UIImage(named: "selectedicon")
                button.setBackgroundImage(image, for: .normal)
                self.pressed = true
            } else {
                
                let image = UIImage(named: "unselected_icon")
                button.setBackgroundImage(image, for: .normal)
                self.pressed = false
            }
        }
        self.termAndConditionButton.touchUp = { button in
            let vc : TermsConditionScannerVC  = TermsConditionScannerVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        skipButton.touchUp = { button in
            if self.pressed == true {
                let profile = Profile.loadProfile()
                self.mViewModel.customer_id = profile?.id ?? 0
                self.mViewModel.title = COMMON_SETTING.name
                self.mViewModel.bodyHeight = COMMON_SETTING.bodyHeight
                self.mViewModel.bodyWeight = COMMON_SETTING.bodyWeight
                self.mViewModel.bodyImage  = []
                
                self.mViewModel.saveMeasurementMultipart {
                    if self.netteloOpened == false {
                        self.netteloOpened = true
                        print("MeasurementID", self.mViewModel.measurementID)
                        
                        let netteloMID = "\(self.mViewModel.customer_id)_\(self.mViewModel.measurementID)"
                        
                        print("netteloMID", netteloMID)
                        ScanBodyViewModel.setTermsConditionsSkipOption(true)
                        self.openNetteloScan(mID: netteloMID, new: true)
                    }
                }                
            } else {
                INotifications.show(message:TITLE.customer_terms_and_condition_msg.localized)
            }
        }
    }
    
    func getApicall() {
        self.viewModel.getScanData {
            if LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue &&
                LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue {
                self.playVideo(url: self.viewModel.data?.men?.english ?? "")
            }else if LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue &&
                LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
                self.playVideo(url: self.viewModel.data?.men?.arabic ?? "")
                
            }else if LocalDataManager.getGenderSelection() == GenderSelection.WOMEN.rawValue &&
                LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue{
                self.playVideo(url: self.viewModel.data?.women?.english ?? "")
                
            }else if LocalDataManager.getGenderSelection() == GenderSelection.WOMEN.rawValue &&
                LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue {
                self.playVideo(url: self.viewModel.data?.women?.arabic ?? "")
            } else {
                
            }
        }
    }
    
    func showPopup() {
        let alert = UIAlertController(title: TITLE.customer_scan_body.localized, message: TITLE.customer_scan_body_desc.localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: TITLE.yes.localized, style: .default, handler:{ action in
            let vc = MeasurementCameraVC.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func playVideo(url: String){
        if let uRLVideo = URL(string: url){
           player = AVPlayer(url: uRLVideo)
            let playerController = AVPlayerViewController()
            playerController.showsPlaybackControls = false
            playerController.player = player
            playerController.delegate = self
            player?.automaticallyWaitsToMinimizeStalling = false
            playerController.videoGravity = .resizeAspect
            playerController.view.backgroundColor = UIColor.black
            self.addChild(playerController)
            self.videoView.addSubview(playerController.view)
            playerController.view.frame = self.videoView.frame
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            //NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")),
               //                                            name: //NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,object: player?.currentItem)
            player?.play()
        }
    }
  
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        skipButton.isUserInteractionEnabled = true
        self.skipButton.setTitle(TITLE.NEXT.localized.uppercased(), for: .normal)
    }
    
    //MARK:- Video Player
    func playButtonClicked() {
        let vc = VideoPlayerVC.loadFromNib()
        
        vc.contentSizeInPopup = CGSize(width: self.view.frame.width - 30, height: 400)
        //vc.navTitle = self.viewModel.vendorDetail?.name ?? ""
        // vc.videoString = self.videoURL
        
        if LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue &&
            LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue {
            vc.videoString = viewModel.data?.men?.english ?? ""
            
        } else if LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue &&
                    LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            vc.videoString = viewModel.data?.men?.arabic ?? ""
            // MEN = it?.data?.Men?.arabicMen
            
        } else if LocalDataManager.getGenderSelection() == GenderSelection.WOMEN.rawValue &&
                    LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue{
            vc.videoString = viewModel.data?.women?.english ?? ""
            // FEMALE = it?.data?.Women?.englishWomen
            
        }else if LocalDataManager.getGenderSelection() == GenderSelection.WOMEN.rawValue &&
                    LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue {
            vc.videoString = viewModel.data?.women?.arabic ?? ""
            // FEMALE = it?.data?.Women?.arabicWomen
        } else{
            vc.videoString = ""
        }
        
        let popupController = STPopupController.init(rootViewController: vc)
        popupController.transitionStyle = .fade
        popupController.containerView.backgroundColor = UIColor.clear
        popupController.backgroundView?.backgroundColor = UIColor.black
        popupController.backgroundView?.alpha = 0.7
        popupController.hidesCloseButton = false
        popupController.navigationBarHidden = true
        popupController.present(in: self, completion: {
            let lButton = ActionButton(type: .custom)
            lButton.setupAction()
            lButton.backgroundColor = UIColor.clear
            lButton.frame = CGRect(x: 0, y: 0, width: MAINSCREEN.size.width, height: MAINSCREEN.size.height)
            lButton.touchUp = { button in
                popupController.dismiss()
            }
            popupController.backgroundView?.addSubview(lButton)
        })
    }

    func playerViewController(_ playerViewController: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("begin")
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("end")
        // playerViewController.view.removeFromSuperview()
//        DispatchQueue.main.async {
       //    playerViewController.dismiss(animated: true, completion: nil)
//        }
    }
    
    func openNetteloScan(mID: String, new: Bool){
        netteloWrapper = NEPhotoTakingWrapper.init(delegate: self)
        netteloWrapper?.setConfiguration(["Token" : "_lfiJgxmdkaahy4v2kZ16g",
                                          "SPEECH_LANGAGE" : LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue ? "ar-SA" : "en-GB"])
        
        var userInfo = [String: Any]()
        userInfo["ExternalId"] = mID
        userInfo["FirstName"] = COMMON_SETTING.name
        userInfo["LastName"] = nil
        userInfo["BirthYear"] = nil
        userInfo["Height"] = Int(COMMON_SETTING.bodyHeight)
        userInfo["Weight"] = Int(COMMON_SETTING.bodyWeight)
        userInfo["Gender"] = LocalDataManager.getGenderSelection() == GenderSelection.WOMEN.rawValue ? "F" : "M"
        userInfo["NewCustomer"] = new
        userInfo["Belly"] = 1
        userInfo["Bust"] = nil
        
        netteloWrapper?.setUserInformation(userInfo)
        
        netteloWrapper?.runPreFlight(completion: { error in
            self.netteloOpened = false
            if error != nil {
                print("ERROOR", error?.localizedDescription ?? "")
                
                if error?.localizedDescription == "NE_PREFLIGHT_DUPLICATEID".localized {
                    self.openNetteloScan(mID: mID, new: false)
                } else if error?.localizedDescription == "NE_PREFLIGHT_UNKNOWNUSER".localized {
                    self.openNetteloScan(mID: mID, new: true)
                } else {
                    IProgessHUD.loaderError(error?.localizedDescription ?? "")
                    self.navigationController?.backToViewController(viewController: BodyDetailVC.self)
                }
            } else {
                self.netteloWrapper?.getViewController({ vc in
                    if let vc = vc {
                        self.player?.pause()
                        self.netteloVC = vc
                        self.navigationController?.present(vc, animated: true)
                    }
                })
            }
        })
    }
    var netteloVC: UIViewController?
}


extension ScanBodyMeasurementVC: NEPhotoTakingDelegate {
    
    func leaving(withReason key: String!) {
        print("LeaveError", key ?? "")
        
        if key == "USER_QUIT" {
            self.netteloVC?.dismiss(animated: true)
        } else if key == "UPLOADING_SEQUENCE" {
            IProgessHUD.show()
        } else if key == "UPLOAD_ERROR" {
            IProgessHUD.dismiss()
            let alert = UIAlertController(title: "", message: key.localizer, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localizer, style: .default, handler: { _ in
                self.netteloVC?.dismiss(animated: true)
                self.navigationController?.backToViewController(viewController: BodyDetailVC.self)
            }))
            self.present(alert, animated: true)
        } else if key == "UPLOAD_DONE" {
            self.mViewModel.updateMeasurementForCartProductNew {
                IProgessHUD.dismiss()
                self.netteloVC?.dismiss(animated: true)
                if COMMON_SETTING.backToM {
                    COMMON_SETTING.backToM = false
                    self.navigationController?.backToViewController(viewController: MeasurementVC.self)
                } else {
                    self.navigationController?.backToViewController(viewController: ShoppingBagVC.self)
                }
            }
        }
    }
}


