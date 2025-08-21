//
//  EnterForotOtpViewController.swift
//  EZAR
//
//  Created by Ankita Firake on 29/05/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit

class EnterForotOtpViewController: UIViewController {

    
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var txtOtp: CustomTextField!
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var btnResetNow: UIButton!
    @IBOutlet weak var lblEnterEmail: UILabel!
    @IBOutlet weak var lblDontArrive: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
       
    }
    
    func configUI() {
        lblForgotPassword.text = TITLE.forgot_pass.localized
        lblEnterEmail.text = TITLE.forget_otp_text.localized
        lblDontArrive.text = TITLE.dont_arrive.localized
        btnResendOtp.setTitle(TITLE.resend_it.localized, for: .normal)
        btnResetNow.setTitle(TITLE.reset_now.localized, for: .normal)
        
    }

    @IBAction func btnResetNowAction(_ sender: Any) {
        let vc = EnterNewPasswordVC.loadFromNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnResedItAction(_ sender: Any) {
    }
}
