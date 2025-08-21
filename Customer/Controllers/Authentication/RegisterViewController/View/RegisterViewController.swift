//
//  RegisterViewController.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import UIKit
import  STPopup
import AuthenticationServices

class RegisterViewController: UIViewController {

    //MARK:- Variables declaration
    //@IBOutlet weak var titleMessageLabel: UILabel!
     @IBOutlet weak var subscribeButton: ActionButton!

    @IBOutlet weak var nameTxt: CustomTextField!
    @IBOutlet weak var codeTxt: CustomTextField!
    @IBOutlet weak var phoneTxt: CustomTextField!
    @IBOutlet weak var cityTxt: CustomTextField!
    @IBOutlet weak var emailTxt: CustomTextField!
    @IBOutlet weak var passwordTxt: CustomTextField!
    @IBOutlet weak var confirmPasswordTxt: CustomTextField!
    @IBOutlet weak var orLabel: UILabel!

    @IBOutlet weak var nextButton: ActionButton!
    @IBOutlet weak var facebookButton: ActionButton!
    @IBOutlet weak var googleButton: ActionButton!
    @IBOutlet weak var alreadyAccountLbl: UILabel!

    @IBOutlet weak var backButton: ActionButton!
    @IBOutlet weak var subscribeLbl: UILabel!
    @IBOutlet weak var appleBtn: ActionButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
   // @IBOutlet weak var lblPrivacyAndConditions: UILabel!
    @IBOutlet weak var lblRegisterThrought: UILabel!
    
    
    
    var isFromNewUserGuest : Bool = false

    let picker = Picker()
    //let countryCode = ["+996","+91", "+1", "+23"]
    let viewModel: RegisterViewModel = RegisterViewModel()
    let countryCode = CountryCode.init(isContryCode: true)
    
    //MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setupValidations()
        setupButtonEvents()
        tapSignUpLbl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configUI()
        if #available(iOS 13.0, *) {
            self.appleBtn.isHidden = false
        }else{
             self.appleBtn.isHidden = true
        }
    }
    
    //MARK:- Helpers
    
    func configUI() {
        self.navigationController?.navigationBar.isHidden = true
        let navigation = self.navigationController as! AVNavigationController
        navigation.statusBarColor(color: UIColor.black)
        
        //self.titleMessageLabel.text = TITLE.customer_signup_title.localized
        
        self.nameTxt.placeholder = TITLE.customer_edit_address_name.localized
        self.phoneTxt.placeholder = TITLE.customer_phone_number_star.localized
        self.cityTxt.placeholder = TITLE.customer_city_star.localized
        self.codeTxt.placeholder = TITLE.Country.localized
        self.emailTxt.placeholder = TITLE.customer_email_address_star.localized
        self.passwordTxt.placeholder = TITLE.customer_password_star.localized
          self.confirmPasswordTxt.placeholder = TITLE.customer_confirm_password_star.localized
        self.orLabel.text = TITLE.Or.localized
        self.subscribeLbl.text = TITLE.customer_subscribed.localized
        self.alreadyAccountLbl.text = TITLE.alreadyMember.localized
        alreadyAccountLbl.addAttributeText(text: TITLE.SIGNIN.localized,textColor : Theme.redColor)
       
        lblName.text = TITLE.sign_up_name.localized
        lblMobileNumber.text = TITLE.sign_up_mobile.localized
        lblCity.text = TITLE.sign_up_city.localized
        lblEmail.text = TITLE.city_placeholder.localized
        lblPassword.text = TITLE.sign_up_password.localized
        lblConfirmPassword.text = TITLE.sign_up_confirmpassword.localized
        //lblPrivacyAndConditions.text = TITLE.sign_up_privacy.localized
        lblRegisterThrought.text = TITLE.sign_up_or.localized
        
        self.backButton.setImage(UIImage.init(named: "back_icon")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
       // self.backButton.setTitle(TITLE.customer_signup.localized, for: .normal)
        phoneTxt.keyboardType = .asciiCapableNumberPad
        emailTxt.keyboardType = .asciiCapable
        emailTxt.addToolBar()
    
    }
    
    func initialize(){
        codeTxt.addToolBar()
        phoneTxt.addToolBar()
        
        if countryCode.countryCodes.count > 0 {
            self.codeTxt.text = (self.countryCode.countryCodes[0])
        }
        
        picker.backgroundColor = .white
        codeTxt.inputView = picker
      
        self.picker.setPickerView(with: self.countryCode.countryCodes, status: true, selectedItem: { (option, row) in
            self.codeTxt.text = (self.countryCode.countryCodes[row])
        })
        
        self.subscribeButton.touchUp = { button in
            if self.viewModel.is_subscribed == 0
            {
                self.viewModel.is_subscribed = 1
                button.setImage(UIImage(named :"selectedicon"), for: .normal)
            }
            else
            {
                self.viewModel.is_subscribed = 0
                button.setImage(UIImage(named:"unselected_icon"), for: .normal)
            }
        }
    }
    
    func setupValidations() {
    nameTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.Name.localized, EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Name.localized.lowercased()))
    
     nameTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.alphabets, ErrorMessage:  MESSAGE.invalidName.localized + TITLE.Name.localized, EmptyMessage: MESSAGE.invalidName.localized + TITLE.Name.localized.lowercased()))
        
     codeTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.countryCode.localized, EmptyMessage: MESSAGE.notEmpty.localized + TITLE.countryCode.localized))
        
        phoneTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.phoneNumber.localized, EmptyMessage: MESSAGE.notEmpty.localized + TITLE.phoneNumber.localized))
        
//         phoneTxt.add(validator: MinLengthValidator.init(validationEvent: ValidatorEvents.none, min : 6,ErrorMessage : MESSAGE.invalidName.localized + TITLE.phoneNumber.localized))
        
        cityTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.City.localized, EmptyMessage: MESSAGE.notEmpty.localized + TITLE.City.localized.lowercased()))
        
        emailTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.mail, ErrorMessage:  MESSAGE.invalidName.localized + TITLE.Email.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Email.localized.lowercased()))
       
        passwordTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.Password.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Password.localized.lowercased()))
        
        passwordTxt.add(validator: MinLengthValidator.init(validationEvent: ValidatorEvents.none, min : 6,ErrorMessage : MESSAGE.passwordLimit.localized))
        
        confirmPasswordTxt.add(validator: CompareValidator(compareTextField: passwordTxt, ErrorMessage: MESSAGE.kConfirmPassword.localized))
        
         confirmPasswordTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.confirmPassword.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.confirmPassword.localized.lowercased()))
        
        
    }
  
    //MARK: Button Action Method
    func setupButtonEvents() {
        //Register Button
        nextButton.touchUp = { button in
           if self.nameTxt.isValid(), self.codeTxt.isValid(), self.phoneTxt.isValid(), self.cityTxt.isValid(), self.emailTxt.isValid() , self.passwordTxt.isValid(), self.confirmPasswordTxt.isValid() {
                self.view.endEditing(true)
                self.registerWebservice()
            }
            
        }
        
      /*  facebookButton.touchUp = { button in
            
            FacebookHelper.fbHelper.fetchFbUserDetails(viewController: self, completionHandler: { (isLoggedin, userDetails) in
                print(userDetails)
                print(isLoggedin)
                if userDetails.count > 0{
                self.socialLoginWebservice(userDetails["email"] as! String, name: userDetails["name"] as! String, social_type: .FACEBOOK, social_login_id: userDetails["id"] as! String)
                    FacebookHelper.fbHelper.fbID = userDetails["id"] as! String
                    FacebookHelper.fbHelper.fbUserName = userDetails["name"] as! String
                }
            })
        }*/
        
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
        
        googleButton.touchUp = { button in
        GoogleSignInHelper.googleHelper.fetchGoogleUserDetails(viewController: self)
        }
        
        backButton.touchUp = { button in
            self.navigationController?.popViewController(animated: true)
        }
        
    }

}

//MARK:- Gmail SignIn Delgate Methods
extension RegisterViewController : GoogleSignInHelperDelegate
{
    func googleSignInDetails(_ notification: [AnyHashable : Any]?) {
        if notification != nil
        {
            if let userDetails = notification!["userDetails"] as? anyDict,userDetails.count > 0  {
                self.socialLoginWebservice(userDetails["email"] as! String, name: userDetails["name"] as! String, social_type: .GOOGLE, social_login_id: userDetails["id"] as! String)
            }
        }
    }
}


//MARK:- TextFieldDelegte Methods

extension RegisterViewController :UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == codeTxt {
            if countryCode.countryCodes.count > 0 {
                self.codeTxt.text = (self.countryCode.countryCodes[0])
            }
        }
    }
    
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
extension RegisterViewController {
    
    func tapSignUpLbl() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        alreadyAccountLbl.isUserInteractionEnabled = true
        alreadyAccountLbl.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        
        let text = (alreadyAccountLbl.text)!
        let range = (text as NSString).range(of: TITLE.SIGNIN.localized)
        
        if gesture.didTapAttributedTextInLabel(label: alreadyAccountLbl, inRange: range) {
            let vc = LoginViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: Webservice Call
extension RegisterViewController {
   
    func registerWebservice() {
        
        self.viewModel.email = self.emailTxt.text!.trimmingCharacters()
        self.viewModel.password = self.passwordTxt.text!.trimmingCharacters()
        self.viewModel.name = self.nameTxt.text!.trimmingCharacters()
        self.viewModel.mobile = self.phoneTxt.text!.trimmingCharacters()
        self.viewModel.city = self.cityTxt.text!.trimmingCharacters()
        self.viewModel.country_code = self.codeTxt.text!.trimmingCharacters()
        self.viewModel.country_code = self.viewModel.country_code.components(separatedBy: " ")[0]
        self.viewModel.confirm_password = self.confirmPasswordTxt.text!.trimmingCharacters()
        self.viewModel.password_confirmation = self.confirmPasswordTxt.text!.trimmingCharacters()
        
        self.viewModel.sendOtpWS {
            let vc = OTPViewController.loadFromNib()
            vc.viewModel.registerViewModel = self.viewModel
            vc.isFromGuestUser = self.isFromNewUserGuest
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func socialLoginWebservice (_ email : String, name : String, social_type : SocialType, social_login_id : String){
        
        self.viewModel.name = name
        self.viewModel.email = email
        self.viewModel.social_type = social_type.rawValue
        self.viewModel.social_login_id = social_login_id
        
        if self.viewModel.email == ""{
            let vc = EmailPopupVc.loadFromNib()
            vc.contentSizeInPopup = CGSize(width: self.view.frame.width, height:self.view.frame.height)
            vc.isFromLogin = false
             vc.isFromNewUserGuest = self.isFromNewUserGuest
            let popupController = STPopupController.init(rootViewController: vc)
            popupController.transitionStyle = .fade
            popupController.containerView.backgroundColor = UIColor.clear
            popupController.backgroundView?.backgroundColor = Theme.lightGray
            popupController.backgroundView?.alpha = 0.8
            popupController.hidesCloseButton = true
            popupController.navigationBarHidden = true
            popupController.present(in: self)            
        } else{
            self.viewModel.getSocialRegister {
                LocalDataManager.setGuestUser(_isGuestUser: false)
                
                if self.isFromNewUserGuest {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                }else{
                    EzarApp.setRootViewController(type: GenderSelectionVC.self)
                }
            }
        }
    }
}
//MARK:-ASAuthorizationControllerDelegate
extension RegisterViewController : ASAuthorizationControllerDelegate{
    
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
extension RegisterViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
