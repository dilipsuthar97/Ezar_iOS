//
// OTPViewController.swift
//  Customer
//
//  Created by Priyanka Jagtap on 14/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//


import UIKit

class OTPViewController: UIViewController{
    
    //MARK:- Variables declaration
    let viewModel :OTPViewModel = OTPViewModel()
    @IBOutlet weak var signUpButton: ActionButton!
    @IBOutlet weak var backButton: ActionButton!
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet weak var resendOTPLabel: UILabel!
    var otpStr : String = ""
    var isFromGuestUser : Bool = false

    @IBOutlet weak var otpInfoLbl: UILabel!
    
    //MARK :-View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        tapResendOtpLbl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       self.configUI()
    }
    
    func initialize(){
        
        //Setup OTP Textfield
        otpView.delegate = self
//        otpView.otpFieldsCount = 6
//        otpView.otpFieldSize = 30
        otpView.initalizeUI()
        otpView.otpFieldDefaultBackgroundColor = Theme.lightGray
        otpView.otpFieldFont = UIFont.init(name: CustomFont.FuturanM.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        backButton.setImage(UIImage.init(named: "back_icon")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)//.titleLabel?.text = TITLE.customer_otp_verification.localized
        
        //self.backButton.titleLabel?.text =  TITLE.customer_otp_verification.localized
        
        otpInfoLbl.text = TITLE.customer_otp_verification_info.localized
        signUpButton.titleLabel?.text = TITLE.customer_signup.localized
        
        self.resendOTPLabel.text = TITLE.customer_resend_otp.localized
        signUpButton.touchUp = { button in
            if self.otpStr != "", self.otpStr.count == 4 {
                self.view.endEditing(true)
               self.submitOTPWebservice()
            } else {
                self.setupValidations()
            }
        }
        
        backButton.touchUp = { button in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func configUI() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupValidations() {
        
        if self.otpStr != "" {
            INotifications.show(message: TITLE.customer_error_invalid_otp.localized)
        } else {
            INotifications.show(message: TITLE.customer_error_invalid_otp.localized)
        }
    }
}

//MARK:- TextFieldDelegte Methods
extension OTPViewController :UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.nextField == nil) {
            textField.resignFirstResponder()
        } else {
            textField.nextField?.becomeFirstResponder()
        }
        return true
    }
}

extension OTPViewController: VPMOTPViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) {
        print("Has entered all OTP? \(hasEntered)")
    }
    
    func enteredOTP(otpString: String) {
    print("OTPString: \(otpString)")
    otpStr = otpString
    }
}

//MARK:- UITapGestureRecognizer
extension OTPViewController {
    
    func tapResendOtpLbl() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        resendOTPLabel.isUserInteractionEnabled = true
        resendOTPLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        
        let text = (resendOTPLabel.text)!
        let range = (text as NSString).range(of: TITLE.customer_resend_otp.localized)
        
        if gesture.didTapAttributedTextInLabel(label: resendOTPLabel, inRange: range) {
            
        print("Resend OTP called")
            resendOTPWebservice()
        }
    }
}

//mark: Webservice Call
extension OTPViewController{
  
    func submitOTPWebservice() {
        self.viewModel.password = self.otpStr
        
        self.viewModel.getRegisterWithOTP {
            LocalDataManager.setGuestUser(_isGuestUser: false)
            if self.isFromGuestUser {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            }else{
                EzarApp.setRootViewController(type: GenderSelectionVC.self)
            }
        }
    }
    
    func resendOTPWebservice(){
        
        self.viewModel.is_reset  = 1
        
        self.viewModel.resendOtpWS {
            
        }
    }
}


