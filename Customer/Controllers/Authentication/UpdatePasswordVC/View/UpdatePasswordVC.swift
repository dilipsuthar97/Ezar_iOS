//
//  UpdatePasswordVC.swift
//  Delegate
//
//  Created by Priyanka Jagtap on 16/08/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class UpdatePasswordVC: BaseViewController {
    
    //MARK: Variable Declaration
    let viewModel :UpdatePWViewModel = UpdatePWViewModel()
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var passwordTextField: CustomTextField!
     @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var submitButton: ActionButton!
    
    //MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupValidations()
    }
    
    func configUI() {
        setNavigationBarHidden(hide: true)
        setLeftButton()
        
        submitButton.setTitle(TITLE.Submit.localized, for: .normal)
        passwordTextField.placeholder = TITLE.Password.localized
        titleLbl.text = TITLE.customer_update_password.localized
        confirmPasswordTextField.placeholder = TITLE.confirmPassword.localized
    }
    
    func setupValidations() {
       
        passwordTextField.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.Password.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Password.localized.lowercased()))
        
        passwordTextField.add(validator: MinLengthValidator.init(validationEvent: ValidatorEvents.none, min : 6,ErrorMessage : MESSAGE.passwordLimit.localized))
        
         confirmPasswordTextField.add(validator: CompareValidator(compareTextField: passwordTextField, ErrorMessage: MESSAGE.kConfirmPassword.localized))
        
        confirmPasswordTextField.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.confirmPassword.localized, EmptyMessage: MESSAGE.notEmpty.localized + TITLE.confirmPassword.localized))
        
       
    }
    
    //MARK: IBAction Method
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if self.passwordTextField.isValid(), self.confirmPasswordTextField.isValid(){
            self.callResetPasswordWS()
        }
   }
}


//MARK: Webservice Call Extension
extension UpdatePasswordVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return newString.count <= 50
    }
    
    
    func callResetPasswordWS(){
        
        let profile = Profile.loadProfile()
        self.viewModel.customer_id = profile?.id ?? 0
        
    self.viewModel.newPassword = self.passwordTextField.text?.trimmingCharacters() ?? ""
        self.viewModel.confirmPassword = self.confirmPasswordTextField.text?.trimmingCharacters() ?? ""

        viewModel.resetPasswordWS { (response) in

            if !response.status! {
                INotifications.show(message: response.message!)
            }
            else{
                IProgessHUD.loaderSuccess(response.message!)
                self.navigationController?.popViewController(animated: true)
            }
        }
   }
}

