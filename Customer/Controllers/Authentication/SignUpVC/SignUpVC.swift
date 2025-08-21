//
//  SignUpVC.swift
//  EZAR
//
//  Created by Ankita Firake on 30/05/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtMobileNumber: CustomTextField!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var txtCity: CustomTextField!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var txtConfirmPassword: CustomTextField!
    @IBOutlet weak var lblPrivacyAndConditions: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblRegisterThrought: UILabel!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnfacebook: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func configUI() {
        lblName.text = TITLE.sign_up_name.localized
        txtName.placeholder = TITLE.sign_up_name.localized
        lblMobileNumber.text = TITLE.sign_up_mobile.localized
        txtMobileNumber.placeholder = TITLE.mobile_placeholder.localized
        lblCity.text = TITLE.sign_up_city.localized
        txtCity.placeholder = TITLE.sign_up_city.localized
        lblEmail.text = TITLE.city_placeholder.localized
        lblPassword.text = TITLE.sign_up_password.localized
        lblConfirmPassword.text = TITLE.sign_up_confirmpassword.localized
        lblPrivacyAndConditions.text = TITLE.sign_up_privacy.localized
        lblRegisterThrought.text = TITLE.sign_up_or.localized
        btnRegister.setTitle(TITLE.sign_up_register.localized, for: .normal)
    }

    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        let vc = VerifyAccountVC.loadFromNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnGoogleAction(_ sender: Any) {
        
    }
    @IBAction func btnFacebookAction(_ sender: Any) {
        
    }
    
}
