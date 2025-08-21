//
//  BankTransferViewController.swift
//  EZAR
//
//  Created by abc on 06/05/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit
import WebKit

class BankTransferViewController: BaseViewController{
    
    var webView: WKWebView!
    var webView_url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        setBackButton()
        navigationItem.title = TITLE.Payment.localized
        setNavigationBarHidden(hide: false)

        webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
        
        let url = URL(string: webView_url)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    override func onClickLeftButton(button: UIButton) {
        if let viewControllers = self.navigationController?.viewControllers{
            for aViewController in viewControllers
            {
                if aViewController is HomeRequestsVC
                {
                    let aVC = aViewController as! HomeRequestsVC
                    
                    _ = self.navigationController?.popToViewController(aVC, animated: true)
                }
            }
        }
    }
}

//MARK:WKScriptMessageHandler, WKNavigationDelegate
extension BankTransferViewController : WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate  {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsHandler" {
            print("got message: \(message.body)")
        }
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        IProgessHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Set the indicator everytime webView started loading
        IProgessHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        IProgessHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        
        if let url = navigationAction.request.url?.description{
            print("url is \(url)")
            if (url.contains("cancel")){
                print("cancel")
            }else if (url.contains("backfromwebview")){
                print("backfromwebview")
                if let viewControllers = self.navigationController?.viewControllers{
                    for aViewController in viewControllers
                    {
                        if aViewController is HomeRequestsVC
                        {
                            let aVC = aViewController as! HomeRequestsVC
                            
                            _ = self.navigationController?.popToViewController(aVC, animated: true)
                        }
                    }
                }
            }
        }
        decisionHandler(.allow)
    }
}
