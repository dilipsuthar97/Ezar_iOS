//
//  VerifyAccountVC.swift
//  EZAR
//
//  Created by Ankita Firake on 31/05/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit

class VerifyAccountVC: UIViewController {

    @IBOutlet weak var lblVerifyAccount: UILabel!
    @IBOutlet weak var txtOtp: CustomTextField!
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var lblEnterEmail: UILabel!
    @IBOutlet weak var lblDontReceive: UILabel!
    
    @IBOutlet weak var btnVerifyAccount: GradientButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        lblVerifyAccount.text = TITLE.verify_account.localized
        lblEnterEmail.text = TITLE.verify_text.localized
        lblDontReceive.text = TITLE.dont_receive.localized
        btnResendOtp.setTitle(TITLE.resend_it.localized, for: .normal)
        btnVerifyAccount.setTitle(TITLE.btn_verify_acc.localized, for: .normal)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnVerifyAccountAction(_ sender: Any) {
        let vc = PopupViewViewController.loadFromNib()
        vc.fromVerifyAcc = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnResedItAction(_ sender: Any) {
    }
}
