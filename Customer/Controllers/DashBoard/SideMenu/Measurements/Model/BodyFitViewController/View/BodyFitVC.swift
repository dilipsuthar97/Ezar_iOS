//
//  BodyFitVC.swift
//  EZAR
//
//  Created by abc on 31/08/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit
import YouTubePlayer

class BodyFitVC: BaseViewController, YouTubePlayerDelegate {

        @IBOutlet weak var button1: ActionButton!
        @IBOutlet weak var button2: ActionButton!
        @IBOutlet weak var button3: ActionButton!
        @IBOutlet weak var button4: ActionButton!
        @IBOutlet weak var noteLbl: UILabel!
        @IBOutlet weak var player: YouTubePlayerView!
        @IBOutlet weak var comfortLabel: UILabel!
    
        var bottomView = ContainerView()
        var viewModel : BodyFitViewModel = BodyFitViewModel()
        var buttonArray : [NSMutableDictionary] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
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
            
            let count = self.viewModel.fit_options_array?.count ?? 0

            for index in 0 ..< count {
                let dictionary : NSMutableDictionary = [:]
                let fitModel = self.viewModel.fit_options_array?[index]
                switch index
                {
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
                let button = dictionary["button"] as! ActionButton
                let video_link  = dictionary["videoLink"] as! String
                let buttonText = dictionary["buttonText"] as! String
                let fit_type = dictionary["fit_type"] as? Int ?? 0

                if button.tag == tag {
                    button.setTitleColor(UIColor(named: "BorderColor"), for: .normal)
                    button.borderColor = UIColor(named: "BorderColor")
                    self.viewModel.selected_type = buttonText
                    self.viewModel.fit_type = fit_type
                    loadWebVideoUrl(videoString: video_link)
                }
                else{
                    button.titleLabel?.textColor = Theme.darkGray
                    button.borderColor = UIColor.clear
                }
            }
        }
        
        func loadWebVideoUrl(videoString : String)
        {
            if let videoUrl : URL = URL.init(string: videoString)
            {
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
            navigationItem.title = TITLE.customer_select_fit.localized
            
            noteLbl.text = TITLE.customer_fit_msg.localized
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

    extension BodyFitVC : ButtonActionDelegate, UIWebViewDelegate
    {
        func onClickBottomButton(button: UIButton) {
            if !(self.viewModel.selected_type.isEmpty)
            {
                let vc = ScanBodyMeasurementVC.loadFromNib()
                COMMON_SETTING.selectType = self.viewModel.selected_type
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

