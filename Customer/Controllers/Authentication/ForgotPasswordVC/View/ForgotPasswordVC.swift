//
//  ForgotPasswordVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseViewController {
    
    //MARK: Variable Declaration
    let viewModel :ForgotPWViewModel = ForgotPWViewModel()

    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var submitButton: ActionButton!
    
    @IBOutlet weak var lblForgotPass: UILabel!
    
    @IBOutlet weak var lblEnterEmail: UILabel!
    //MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupValidations()
    }
    
    func configUI() {
        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.customer_forgot_password_title.localized
        setLeftButton()
        
        self.emailTextField.placeholder = TITLE.Email.localized
        self.submitButton.titleLabel?.text = TITLE.Submit.localized
        self.lblEnterEmail.text = TITLE.enter_email.localized
        self.lblForgotPass.text = TITLE.forgot_pass.localized
        
    }
    
    func setupValidations() {
        //COMMON_SETTING.getTextFieldAligment(textField: emailTextField) //Some issues
        emailTextField.add(validator: PatternValidator.init(pattern: ValidatorRegex.mail, ErrorMessage:  MESSAGE.invalidName.localized + TITLE.Email.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Email.localized.lowercased()))
    }
    
    //MARK: IBAction Method
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if self.emailTextField.isValid(){
            self.callForgetPasswordWS()
        }
   }
}


//MARK: Webservice Call Extension
extension ForgotPasswordVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return newString.count <= 50
    }
    
    func callForgetPasswordWS(){
        
    self.viewModel.email = self.emailTextField.text?.trimmingCharacters() ?? ""

        viewModel.getForgotPasswordWS { (response) in
            
            if !response.status! {
                INotifications.show(message: response.message!)
            }
            else{
                IProgessHUD.loaderSuccess(response.message!)
                let vc = PopupViewViewController.loadFromNib()
                vc.fromForgetVC = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
   }
}

