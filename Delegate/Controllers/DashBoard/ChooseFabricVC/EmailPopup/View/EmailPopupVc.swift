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
    let viewModel :LoginViewModel = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpvalidator()
        
        self.emailLabel.text = TITLE.Email.localized
    self.submitBtn.setTitle(TITLE.Submit.localized.uppercased(), for: .normal)
        self.emailTxt.placeholder = MESSAGE.notEmpty.localized + TITLE.Email.localized
        
        submitBtn.touchUp = { button in
            if self.emailTxt.isValid(){
                self.view.endEditing(true)
                self.viewModel.email = self.emailTxt.text ?? ""
                self.viewModel.name = FacebookHelper.fbHelper.fbUserName
                self.viewModel.social_type = SocialType.FACEBOOK.rawValue
                self.viewModel.social_login_id = FacebookHelper.fbHelper.fbID
                self.viewModel.getSocialLogin {
                    
                    LocalStore.setGuestUser(_isGuestUser: false)
                    if let vc  = COMMON_SETTINGS.getViewControllerFromStoryBoard(type: BaseNavigationController.self){
                        
                        if let homeVC  = COMMON_SETTINGS.getViewControllerFromNib(type: HomeRequestsVC.self)
                        {
                            homeVC.backButtonTitle = LocalStore.getGenderSelection() == GenderSelection.MEN.rawValue ? .MEN : .WOMEN
                            vc.setViewControllers([homeVC], animated: true)
                        }
                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                        appdelegate.window!.rootViewController = vc
                    }
                }
                
            }
        }
        
        cancelButton?.touchUp = { button in
            self.dismiss(animated: true, completion: nil)
            COMMON_SETTINGS.showToast(message: "Facebook Registration Canceled")
        }
    }
    
    func setUpvalidator(){
         emailTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.mail, ErrorMessage:  MESSAGE.invalidName.localized + TITLE.Email.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Email.localized.lowercased()))
    }
}

//MARK:- TextFieldDelegte Methods

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
