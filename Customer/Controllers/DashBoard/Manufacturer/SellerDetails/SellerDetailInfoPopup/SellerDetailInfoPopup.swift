//
//  SellerDetailInfoPopup.swift
//  Customer
//
//  Created by webwerks on 4/3/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import SafariServices

protocol SellerDetailInfoPopUpDelegate{
    
    func onClickCloseInfoBtn()
}

class SellerDetailInfoPopup: UIViewController {

    var delegate: SellerDetailInfoPopUpDelegate? = nil
    
    @IBOutlet weak var downloadBtnView: UIView!
    @IBOutlet weak var downLoadBtn: ActionButton!
    
    @IBOutlet weak var closeInfoButton: ActionButton!{
        didSet{
            closeInfoButton.layer.masksToBounds = true
            closeInfoButton.layer.cornerRadius = 12
        }
    }
    var infoStr : String = ""
    var pdfUrl : String = ""
    var pdfURL: URL!
    
    @IBOutlet weak var cancelButton: ActionButton!
    @IBOutlet weak var webView: UIWebView!

    override func awakeFromNib() {
        self.contentSizeInPopup = CGSize(width: self.view.frame.width - 30, height: 380)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.downLoadBtn.setTitle(TITLE.customer_DownloadPdf.localized, for: .normal)
            if pdfUrl.isEmpty{
                self.downloadBtnView.isHidden = true
            }else{
                self.downloadBtnView.isHidden = false
                
                self.downLoadBtn.touchUp = { button in
                    
                    guard let url = URL(string: self.pdfUrl) else { return }
                    
                    let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
                    
                    let downloadTask = urlSession.downloadTask(with: url)
                    downloadTask.resume()
                    IProgessHUD.show()

                }
            }
        
     
       // webView.delegate = self
        self.closeInfoButton.setTitle(TITLE.customer_info_minus.localized, for: .normal)
        DispatchQueue.main.async {
//           self.webView?.loadRequest(self.infoStr!)
            self.webView.delegate = self
            self.webView.loadHTMLString(self.infoStr, baseURL: nil)
        }
       
        closeInfoButton?.touchUp = { button in
            self.dismiss(animated: true, completion: nil)
            self.delegate?.onClickCloseInfoBtn()
        }
        
        cancelButton?.touchUp = { button in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SellerDetailInfoPopup: UIWebViewDelegate
{
   func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool
   {
        print(request)
        if let url = request.url, UIApplication.shared.canOpenURL(url)
        {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true)
            return false
        }
        return true
    }
}

//MARK:-  URLSessionDownloadDelegate
extension SellerDetailInfoPopup:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.pdfURL = destinationURL
            
          
                if #available(iOS 11.0, *) {
                     DispatchQueue.main.async {
                    let pdfViewController = PDFViewController()
                    pdfViewController.pdfURL = self.pdfURL
                    IProgessHUD.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                            INotifications.show(message: TITLE.customer_Download_Success.localized)
                        }
                    self.present(pdfViewController, animated: false, completion: nil)
                    }
                } else {
                    // Fallback on earlier versions
                    INotifications.show(message: TITLE.customer_not_downloaded.localized)
                }
                
            
            
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
