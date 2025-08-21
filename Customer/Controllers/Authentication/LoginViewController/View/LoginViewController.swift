//
//  LoginViewController.swift
//  Thoab
//
//  Created by webwerks on 05/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import UIKit
import STPopup
import AuthenticationServices

class LoginViewController: UIViewController{
    
    //MARK:- Variables declaration
    @IBOutlet weak var usernameTxt: CustomTextField!
    @IBOutlet weak var passwordTxt: CustomTextField!
    
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var backBtn: ActionButton!
    @IBOutlet weak var loginButton: ActionButton!
    @IBOutlet weak var forgetButton: ActionButton!
    @IBOutlet weak var facebookButton: ActionButton!
    @IBOutlet weak var googleButton: ActionButton!
    @IBOutlet weak var dontAccountLbl: UILabel!
    @IBOutlet weak var skipBtn: ActionButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var appleBtn: ActionButton!

    @IBOutlet weak var btnRegisterNow: ActionButton!
    @IBOutlet weak var lblPassword: UILabel!
    
    var isFromUserGuest : Bool = false
    var isFromIntroImages : Bool = false

    let viewModel :LoginViewModel = LoginViewModel()
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
          setupValidations()
          setupButtonEvents()
          tapSignUpLbl()
          initialize()
        
        
        if #available(iOS 13.0, *) {
            self.appleBtn.isHidden = false
        }else{
             self.appleBtn.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configUI()
        self.usernameTxt.text = ""
        self.passwordTxt.text = ""
    }
    
    
    //MARK:- Helpers
    
    func configUI() {
    
        self.navigationController?.navigationBar.isHidden = true
        let navigation = self.navigationController as! AVNavigationController
        navigation.statusBarColor(color: UIColor.white)
        self.backBtn.setImage(UIImage.init(named: "Back_Black")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        //self.backBtn
        self.backBtn.isHidden = true
        if isFromIntroImages == true {
            self.backBtn.isHidden = true
        }else{
            self.backBtn.isHidden = true
        }
        self.backBtn.touchUp = { button in
                self.navigationController?.popViewController(animated: true)
        }
        self.backBtn.setTitle(TITLE.SIGNIN.localized, for: .normal)
        
//        COMMON_SETTING.setRTLforTextField(textField: self.usernameTxt)
//        COMMON_SETTING.setRTLforTextField(textField: self.passwordTxt)
    }
    
    func initialize() {
        
        self.dontAccountLbl.text = TITLE.customer_no_account.localized
        dontAccountLbl.addAttributeText(text: TITLE.signup.localized,textColor : UIColor(named: "dark_gradient")!)
        self.orLabel.text = TITLE.Or.localized
        self.loginButton.setTitle(TITLE.Login.localized.uppercased(), for: .normal)
        self.skipBtn.setTitle(TITLE.customer_skipSign.localized, for: .normal)
        self.usernameTxt.placeholder = TITLE.customer_username.localized
        self.passwordTxt.placeholder = TITLE.Password.localized
        self.forgetButton.setTitle(TITLE.forgotPassword.localized, for: .normal)
        self.lblEmail.text = TITLE.sign_up_email.localized
        self.lblPassword.text = TITLE.sign_up_password.localized
        self.btnRegisterNow.setTitle(TITLE.register_now.localized, for: .normal)
        usernameTxt.addToolBar()
        self.usernameTxt.text = ""
        self.passwordTxt.text = ""
    }
  
    func setupValidations() {
        
        usernameTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.mail, ErrorMessage:  MESSAGE.invalidName.localized + TITLE.Email.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Email.localized.lowercased()))
        
        passwordTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.Password.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Password.localized.lowercased()))
    }
    
    func setupButtonEvents() {
        
        facebookButton.touchUp = { button in
            LocalDataManager.setGuestUser(_isGuestUser: false)
            FacebookHelper.fbHelper.fetchFbUserDetails(viewController: self, completionHandler: { (isLoggedin, userDetails) in
                print(userDetails)
                print(isLoggedin)
                if userDetails.count > 0{
                self.socialLoginWebservice(userDetails["email"] as! String, name: userDetails["name"] as! String, social_type: .FACEBOOK, social_login_id: userDetails["id"] as! String)
                    FacebookHelper.fbHelper.fbID = userDetails["id"] as! String
                    FacebookHelper.fbHelper.fbUserName = userDetails["name"] as! String
                }
            })
        }
        
        googleButton.touchUp = { button in
            LocalDataManager.setGuestUser(_isGuestUser: false)
            GoogleSignInHelper.googleHelper.fetchGoogleUserDetails(viewController: self)
        }
        
        appleBtn.touchUp = { button in
            if #available(iOS 13.0, *) {
                LocalDataManager.setGuestUser(_isGuestUser: false)
               let request = ASAuthorizationAppleIDProvider().createRequest()
                request.requestedScopes = [.fullName, .email]
                
                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
            } else {
                // Fallback on earlier versions
            }
        }
        
        forgetButton.touchUp = { button in
            let vc = ForgotPasswordVC.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        skipBtn.touchUp = { button in
            LocalDataManager.setGuestUser(_isGuestUser: true)
            if LocalDataManager.getGenderSelection() == GenderSelection.NONE.rawValue {
                let vc = GenderSelectionVC.loadFromNib()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                APP_DELEGATE.setHomeView()
            }
        }
                   
        //Login Button Action
        loginButton.touchUp = { button in
            if self.usernameTxt.isValid() , self.passwordTxt.isValid() {
                self.view.endEditing(true)
                LocalDataManager.setGuestUser(_isGuestUser: false)
                self.loginWebservice(self.usernameTxt.text!, password: self.passwordTxt.text!, social_type: .NORMAL)
            }
            
        }
        
        btnRegisterNow.touchUp = { button in
            let vc = RegisterViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        if #available(iOS 13.0, *) {
            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                            ASAuthorizationPasswordProvider().createRequest()]
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
}

//MARK:- Gmail SignIn Delgate Methods
extension LoginViewController : GoogleSignInHelperDelegate
{
    func googleSignInDetails(_ notification: [AnyHashable : Any]?) {
        if notification != nil
        {
                if let userDetails = notification!["userDetails"] as? anyDict,userDetails.count > 0 {
                self.socialLoginWebservice(userDetails["email"] as! String, name: userDetails["name"] as! String, social_type: .GOOGLE, social_login_id: userDetails["id"] as! String)
            }
        }
    }
}

//MARK:- TextFieldDelegte Methods

extension LoginViewController :UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.nextField == nil) {
            textField.resignFirstResponder()
        } else {
            textField.nextField?.becomeFirstResponder()
        }
        return true
    }
}

//MARK:- UITapGestureRecognizer

extension LoginViewController {
    
    func tapSignUpLbl() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        dontAccountLbl.isUserInteractionEnabled = true
        dontAccountLbl.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (dontAccountLbl.text)!
        let range = (text as NSString).range(of: TITLE.signup.localized)        
        if gesture.didTapAttributedTextInLabel(label: dontAccountLbl, inRange: range) {
            let vc = RegisterViewController.loadFromNib()
            vc.isFromNewUserGuest = self.isFromUserGuest
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: Webservice call
extension LoginViewController {
    
    func loginWebservice(_ email : String, password : String, social_type : SocialType){
       
        self.viewModel.email = email.trimmingCharacters()
        self.viewModel.password = password.trimmingCharacters()
        self.viewModel.social_type = social_type.rawValue
     
        self.viewModel.getLoginWS {
            let profile = Profile.loadProfile()
            
            if profile?.is_forgot == 1 {
                let vc = UpdatePasswordVC.loadFromNib()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
                if LocalDataManager.getGenderSelection() == GenderSelection.NONE.rawValue {
                    let vc = GenderSelectionVC.loadFromNib()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if LocalDataManager.getUserSelection().isEmpty {
                    let vc = SelectSectionVC.loadFromNib()
                    vc.rightTitle = LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue ? .MEN : .WOMEN
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    if self.isFromUserGuest {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        APP_DELEGATE.setHomeView()
                    }
                }
            }
        }
    }
    
    func socialLoginWebservice (_ email : String, name : String, social_type : SocialType, social_login_id : String){
        
        self.viewModel.name = name
        self.viewModel.email = email
        self.viewModel.social_type = social_type.rawValue
        self.viewModel.social_login_id = social_login_id
        
        if self.viewModel.email == "" {
            let vc = EmailPopupVc.loadFromNib()
             vc.contentSizeInPopup = CGSize(width: self.view.frame.width, height:self.view.frame.height)
            vc.isFromLogin = true
            let popupController = STPopupController.init(rootViewController: vc)
            popupController.transitionStyle = .fade
            popupController.containerView.backgroundColor = UIColor.clear
            popupController.backgroundView?.backgroundColor = Theme.lightGray
            popupController.backgroundView?.alpha = 0.8
            popupController.hidesCloseButton = true
            popupController.navigationBarHidden = true
            popupController.present(in: self)
        } else {
            self.viewModel.getSocialLogin {
                LocalDataManager.setGuestUser(_isGuestUser: false)
                let profile = Profile.loadProfile()
                
                if profile?.is_forgot == 1{
                    let vc = UpdatePasswordVC.loadFromNib()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    if LocalDataManager.getGenderSelection() == GenderSelection.NONE.rawValue {
                        let vc = GenderSelectionVC.loadFromNib()
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        if self.isFromUserGuest {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            APP_DELEGATE.setHomeView()
                        }
                    }
                }
            }
        }
    }
}

//MARK:-ASAuthorizationControllerDelegate
extension LoginViewController : ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName ?? ""
            let userLastName = appleIDCredential.fullName?.familyName ?? ""
            let fullName = userFirstName + " " + userLastName
            
            let email = appleIDCredential.email
            
            self.socialLoginWebservice(email ?? "", name: (String(describing: fullName)), social_type: .APPLE, social_login_id: (String(describing: userIdentifier)))
            
            break
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
        default:
            break
        }
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
       // INotifications.show(message: ERROR_MSG.kServerError.localized)
    }
}
//MARK:ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
