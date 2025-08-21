//
//  EmailPopupVc.swift
//  EZAR
//
//  Created by Shruti Gupta on 1/9/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit

class EmailPopupVc: UIViewController {
    
    @IBOutlet weak var emailTxt: CustomTextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cancelButton: ActionButton!
    @IBOutlet weak var submitBtn: ActionButton!
    let registerViewModel: RegisterViewModel = RegisterViewModel()
    let viewModel :LoginViewModel = LoginViewModel()
    var isFromLogin : Bool = false
    var isFromNewUserGuest : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpvalidator()
        
        emailLabel.text = TITLE.Email.localized
        submitBtn.setTitle(TITLE.Submit.localized.uppercased(), for: .normal)
        emailTxt.placeholder = MESSAGE.notEmpty.localized + TITLE.Email.localized
        
        submitBtn.touchUp = { button in
            if self.emailTxt.isValid() {
                if self.isFromLogin == true {
                    self.viewModel.email = self.emailTxt.text ?? ""
                    self.viewModel.name = FacebookHelper.fbHelper.fbUserName
                    self.viewModel.social_type = SocialType.FACEBOOK.rawValue
                    self.viewModel.social_login_id = FacebookHelper.fbHelper.fbID
                    self.viewModel.getSocialLogin {
                        LocalDataManager.setGuestUser(_isGuestUser: false)
                        self.dismiss(animated: true, completion: nil)
                        APP_DELEGATE.setHomeView()
                    }
                } else {
                    self.registerViewModel.email = self.emailTxt.text ?? ""
                    self.registerViewModel.name = FacebookHelper.fbHelper.fbUserName
                    self.registerViewModel.social_type = SocialType.FACEBOOK.rawValue
                    self.registerViewModel.social_login_id = FacebookHelper.fbHelper.fbID
                    
                    self.registerViewModel.getSocialRegister {
                        LocalDataManager.setGuestUser(_isGuestUser: false)
                        if self.isFromNewUserGuest{
                            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                        }else{
                            EzarApp.setRootViewController(type: GenderSelectionVC.self)
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        cancelButton?.touchUp = { button in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setUpvalidator(){
        emailTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.mail, ErrorMessage:  MESSAGE.invalidName.localized + TITLE.Email.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Email.localized.lowercased()))
    }
}

//MARK: - TextFieldDelegte Methods
extension EmailPopupVc :UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.nextField == nil) {
            textField.resignFirstResponder()
        } else {
            textField.nextField?.becomeFirstResponder()
        }
        return true
    }
}
