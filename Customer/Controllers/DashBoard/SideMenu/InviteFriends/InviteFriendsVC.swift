//
//  InviteFriendsVC.swift
//  Homekooc
//
//  Created by Volkoff on 08/08/19.
//

import UIKit
import MessageUI

class InviteFriendsVC: DynamaticLinkVC {

    let inviteFriendService = InviteFriendService()
    var shareURL: String? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!

    @IBOutlet weak var copyButton: ActionImageView! {
        didSet{
            copyButton.isHidden = true
        }
    }
    
    @IBOutlet weak var messageButton: ActionImageView!
    @IBOutlet weak var whatappButton: ActionImageView!
    @IBOutlet weak var mailButton: ActionImageView!
    @IBOutlet weak var shareButton: ActionImageView!

    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let referralCode = LocalDataManager.getReferralCode()
        if referralCode.isEmpty {
            getReferralCodeAPI()
        } else {
            copyButton.isHidden = false
            codeLabel.text = referralCode
            
            let link = LocalDataManager.getShareLink()
            if link.isNotEmpty {
                self.shareURL = link
            } else {
                self.createShareableLink()
            }
        }
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureUI()
        setupNavigation()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupNavigation() {
        self.navigationItem.title = "intive_friends".localized
        setNavigationBarHidden(hide: false)
        setLeftButton()
    }
    
    private func configureUI() {
        titleLabel.text = "your_referral_code".localized
        detailsLabel.text = "your_referral_code2".localized
        
        copyButton.touchUp = { img in
            self.onPressCopyButton()
        }
        
        whatappButton.touchUp = { img in
            self.openWhatApp()
        }
        
        messageButton.touchUp = { img in
            self.openMessage()
        }
        
        mailButton.touchUp = { img in
            self.openEmail()
        }
        
        shareButton.touchUp = { img in
            self.onPressShareButton()
        }
    }
    
    func onPressCopyButton() {
        guard let url = self.shareURL else {
            return
        }
        
        let text = "your_referral_code2".localized
        let finalText = "\(text) \n \(url)"

        INotifications.show(message: "your_referral_code_copy".localized)
        let pasteboard = UIPasteboard.general
        pasteboard.string = finalText
    }
    
    func openWhatApp() {
        guard let url = self.shareURL else {
            return
        }
        
        let text = "your_referral_code2".localized
        
        let finalText = "\(text) \n \(url)"
        let urlStringEncoded = finalText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        if let whatsappURL  = URL(string: "whatsapp://send?text=\(urlStringEncoded!)") {
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL,
                                          options: [:],
                                          completionHandler: nil)
            }
        }
    }
    
    func openMessage() {
        guard let url = self.shareURL else {
            return
        }
        let text = "your_referral_code2".localized
        let finalText = "\(text) \n \(url)"
        let sms = "sms: &body=\(finalText)"
        let strURL = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    func openEmail() {
        guard let url = self.shareURL else {
            return
        }

        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([])
        composeVC.setSubject("intive_friends_2".localized)
        
        let text = "your_referral_code2".localized
        let finalText = "\(text) \n \(url)"
        composeVC.setMessageBody(finalText, isHTML: false)
        present(composeVC, animated: true, completion: nil)
    }
    
    func onPressShareButton() {
        guard let url = self.shareURL else {
            return
        }

        let text = "your_referral_code2".localized
        let shareAll = [text, url] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll,
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension InviteFriendsVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error _: Error?) {
        switch result {
        case .sent:
            INotifications.show(message: "email_sent".localized)
            controller.dismiss(animated: true, completion: nil)
        default:
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

extension InviteFriendsVC {
    
    func getReferralCodeAPI() {
        var params = anyDict()
        
        let profile = Profile.loadProfile()
        params["customer_id"] = profile?.id ?? 0

        IProgessHUD.show()
        inviteFriendService.getReferralCodeWS(for: params) {
            self.copyButton.isHidden = false
            self.codeLabel.text = LocalDataManager.getReferralCode()
            self.shareURL = LocalDataManager.getShareLink()
            if ((self.shareURL?.isEmpty) != nil) {
                self.createShareableLink()
            }
        }
    }
    
    func createShareableLink() {
        shareInviteLink(inviteCode: LocalDataManager.getReferralCode(),
                        completionHandler: { link in
            if let link = link {
                LocalDataManager.saveShareLink(link)
                self.saveInviteLinkAPI(link: link)
                return
            }
        })
    }
    
    func saveInviteLinkAPI(link: String) {
        var params = anyDict()
        
        let profile = Profile.loadProfile()
        params["customer_id"] = profile?.id ?? 0
        params["url"] = link

        inviteFriendService.getReferralCodeWS(for: params) {
            self.shareURL = LocalDataManager.getShareLink()
        }
    }
}
