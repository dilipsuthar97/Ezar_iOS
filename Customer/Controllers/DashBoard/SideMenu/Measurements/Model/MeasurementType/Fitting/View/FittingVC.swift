//
//  FittingVC.swift
//  Customer
//
//  Created by webwerks on 7/10/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import YouTubePlayer

class FittingVC: BaseViewController, YouTubePlayerDelegate {

    @IBOutlet weak var button1: ActionButton!
    @IBOutlet weak var button2: ActionButton!
    @IBOutlet weak var button3: ActionButton!
    @IBOutlet weak var button4: ActionButton!
    @IBOutlet weak var noteLbl: UILabel!

    @IBOutlet weak var player: YouTubePlayerView!
    var bottomView = ContainerView()
    var viewModel : MeasurementDetailViewModel = MeasurementDetailViewModel()
    var buttonArray : [NSMutableDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel.selected_type = ""
        self.setupUI()
        self.setCustomBottomBar()
        self.buttonActions()
    }
    
    func buttonActions()
    {
        self.button1.isHidden = true
        self.button2.isHidden = true
        self.button3.isHidden = true
        self.button4.isHidden = true
        
        let count : Int = (self.viewModel.measuremetTemplate?.fitOptions.count) ?? 0
        
        for index in 0 ..< count {
            let dictionary : NSMutableDictionary = [:]
            let fitModel = self.viewModel.measuremetTemplate?.fitOptions[index]
            switch index {
            case 0:
                self.button1.isHidden = false
                self.button1.setTitle(fitModel?.show_label, for: .normal)
                dictionary.addEntries(from: ["button":self.button1,
                                             "videoLink":fitModel?.video_link ?? "",
                                             "fit_type":fitModel?.id ?? 0,
                                             "buttonText":fitModel?.show_label ?? ""])
                buttonArray.append(dictionary)
                break
            case 1:
                self.button2.isHidden = false
                self.button2.setTitle(fitModel?.show_label, for: .normal)
                dictionary.addEntries(from: ["button":self.button2,
                                             "videoLink":fitModel?.video_link ?? "",
                                             "fit_type":fitModel?.id ?? 0,
                                             "buttonText":fitModel?.show_label ?? ""])
                buttonArray.append(dictionary)
                break
            case 2:
                self.button3.isHidden = false
                self.button3.setTitle(fitModel?.show_label, for: .normal)
                dictionary.addEntries(from: ["button":self.button3,
                                             "videoLink":fitModel?.video_link ?? "",
                                             "fit_type":fitModel?.id ?? 0,
                                             "buttonText":fitModel?.show_label ?? ""])
                buttonArray.append(dictionary)
                break
            case 3:
                self.button4.isHidden = false
                self.button4.setTitle(fitModel?.show_label, for: .normal)
                dictionary.addEntries(from: ["button":self.button4,
                                             "videoLink":fitModel?.video_link ?? "",
                                             "fit_type":fitModel?.id ?? 0,
                                             "buttonText":fitModel?.show_label ?? ""])
                buttonArray.append(dictionary)
                break
            default:
                break
            }
        }
        self.changeTheSelectedButton(tag: self.button1.tag)
        self.button1.touchUp = { button in
            self.changeTheSelectedButton(tag: button.tag)
        }
        self.button2.touchUp = { button in
            self.changeTheSelectedButton(tag: button.tag)
        }
        self.button3.touchUp = { button in
            self.changeTheSelectedButton(tag: button.tag)
        }
        self.button4.touchUp = { button in
            self.changeTheSelectedButton(tag: button.tag)
        }
    }
    
    func changeTheSelectedButton(tag : Int) {
        for dictionary in buttonArray {
            let button : ActionButton = dictionary["button"] as! ActionButton
            let video_link : String = dictionary["videoLink"] as! String
            let buttonText: String = dictionary["buttonText"] as! String
            let fit_type = dictionary["fit_type"] as? Int ?? 0
            
            if button.tag == tag {
                button.setTitleColor(Theme.redColor, for: .normal)
                button.borderColor = Theme.redColor
                self.viewModel.selected_type = buttonText
                self.viewModel.fit_type = fit_type
                loadWebVideoUrl(videoString: video_link)
            } else {
                button.titleLabel?.textColor = Theme.darkGray
                button.borderColor = UIColor.clear
            }
        }
    }
    
    func loadWebVideoUrl(videoString : String) {
        if let videoUrl : URL = URL.init(string: videoString) {
            player.playerVars = ["modestbranding" : 0 as AnyObject,"controls" : 1 as AnyObject ,"autoplay" : 1 as AnyObject,"playsinline" : 1 as AnyObject,"autohide" : 1 as AnyObject,"showinfo" : 0 as AnyObject]
            player.loadVideoURL(videoUrl)
            player.delegate = self
        }
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.MeasurementDetail.localized

        noteLbl.text = TITLE.videoDescription.localized
        self.button1.titleLabel?.text = TITLE.slim.localized
        self.button2.titleLabel?.text = TITLE.superslim.localized
        self.button3.titleLabel?.text = TITLE.Loose.localized
        self.button4.titleLabel?.text = TITLE.comfort.localized

    }
    
    //MARK:- Helpers for Custom Bottom Bar
    func setCustomBottomBar(){
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.NEXT.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 50)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }
    
}

extension FittingVC : ButtonActionDelegate, UIWebViewDelegate
{
    func onClickBottomButton(button: UIButton) {
        if !(self.viewModel.selected_type.isEmpty)
        {
            let vc = TakeMeasurementViewController.loadFromNib()
            vc.viewModel.measurementDetailModel = self.viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            INotifications.show(message: TITLE.customer_option_selection.localized)
        }
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        IProgessHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        IProgessHUD.dismiss()
    }
}
