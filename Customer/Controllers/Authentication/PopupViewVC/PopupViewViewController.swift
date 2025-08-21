//
//  PopupViewViewController.swift
//  EZAR
//
//  Created by Ankita Firake on 28/05/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit

class PopupViewViewController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var popupText: UILabel!
    var fromForgetVC = false
    var confirmPassVC = false
    var fromVerifyAcc = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblText()
        configUI()
    }
    func configUI() {
        if fromForgetVC {
            popupText.text = TITLE.forget_pass_popup.localized
        } else if confirmPassVC {
            popupText.text = TITLE.reset_pass_popup.localized
        } else if fromVerifyAcc {
            popupText.text = TITLE.verify_acc_popup.localized
        }
    }
    
    func lblText() {
        if fromForgetVC {
            popupText.text = "The password recovery code has been sent successfully info@gmail.com to"
            let range = ((popupText.text! ) as NSString).range(of: popupText.text ?? "")
            
            let underlineAttriString = NSMutableAttributedString(string: popupText.text ?? "", attributes: nil)
            let changeText = "The password recovery code has been sent successfully "
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Cairo-Regular", size: 15), range: range)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "BorderColor"), range: range)
            
            let range1 = ((popupText.text! ) as NSString).range(of: changeText)
            underlineAttriString.addAttribute(NSAttributedString.Key(rawValue: "idnum"), value: "1", range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range1)
            
            let range3 = ((popupText.text! ) as NSString).range(of: changeText)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range3)
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15), range: range3)
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Cairo-Regular", size: 15), range: range3)
            popupText.attributedText = underlineAttriString
            
        } else if fromVerifyAcc {
            popupText.text = "Your account was verified Successfully"
        
            
        } else {
            popupText.text = "New password was reseted Successfully"
        }
    }
    
    
    @IBAction func btnNavigationAction(_ sender: Any) {
        if fromForgetVC {
            let vc = EnterForotOtpViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if confirmPassVC {
            let vc = LoginViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if fromVerifyAcc {
            let vc = LoginViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        }        
    }
}
