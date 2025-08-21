//
//  VideoPlayerVC.swift
//  Customer
//
//  Created by webwerks on 4/3/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import STPopup
import YouTubePlayer

protocol VideoPlayerPopUpDelegate{
    
    func onClickCloseInfoBtn()
}

class VideoPlayerVC: UIViewController, YouTubePlayerDelegate {
  
    var delegate: VideoPlayerPopUpDelegate? = nil
     @IBOutlet weak var player: YouTubePlayerView!

    //MARK:- Required Variables
    var navTitle : String = "back_icon"
    var videoString : String = "" //"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.popupController?.navigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true

      //  self.setupUI()
        self.playVideo()
        
//        cancelButton?.touchUp = { button in
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        let leftNavigationButton =  self.navigationItem.leftButton(title: self.navTitle, imgName: "back_icon")
        leftNavigationButton.touchUp = { button in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- Helpers for Video Play
    func playVideo()
    {
        if let videoUrl : URL = URL.init(string: videoString)
        {
            IProgessHUD.show()
            player.playerVars = ["modestbranding" : 0 as AnyObject,"controls" : 1 as AnyObject ,"autoplay" : 1 as AnyObject,"playsinline" : 1 as AnyObject,"autohide" : 1 as AnyObject,"showinfo" : 0 as AnyObject]
            player.loadVideoURL(videoUrl)
            player.delegate = self
        }
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        IProgessHUD.dismiss()
        videoPlayer.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension VideoPlayerVC : UIWebViewDelegate
{
    func webViewDidStartLoad(_ webView: UIWebView) {
        IProgessHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        IProgessHUD.dismiss()
    }
}
