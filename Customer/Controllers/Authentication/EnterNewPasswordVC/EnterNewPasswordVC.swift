//
//  EnterNewPasswordVC.swift
//  EZAR
//
//  Created by Ankita Firake on 29/05/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit

class EnterNewPasswordVC: UIViewController {

    
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblNewPassword: UILabel!
    @IBOutlet weak var txtConfirmPassword: CustomTextField!
    @IBOutlet weak var txtNewPassword: CustomTextField!
    @IBOutlet weak var btnConfirm: GradientButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    func configUI() {
        lblNewPassword.text = TITLE.new_password.localized
        lblDescription.text = TITLE.new_pass_text.localized
        txtNewPassword.placeholder = TITLE.new_password.localized
        txtConfirmPassword.placeholder = TITLE.confirm_new_password.localized
        btnConfirm.setTitle(TITLE.confirm_btn.localized, for: .normal)
    }

    @IBAction func btnConfirmAction(_ sender: Any) {
        let vc = PopupViewViewController.loadFromNib()
        vc.confirmPassVC = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
