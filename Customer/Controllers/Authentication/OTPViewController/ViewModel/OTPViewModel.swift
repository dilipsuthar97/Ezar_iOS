//
// OTPViewModel.swift
//  Customer
//
//  Created by Priyanka Jagtap on 14/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject
class OTPViewModel: NSObject {
    
    let APIClient : OTPAPIClient
    var password : String = ""
    var registerViewModel: RegisterViewModel = RegisterViewModel()
    var is_reset         : Int = 0
    
    init(apiClient: OTPAPIClient = OTPAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Register
    func getRegisterWithOTP(complete: @escaping isCompleted) {
        
        let params: NSMutableDictionary = [API_KEYS.name : registerViewModel.name,
                                            API_KEYS.otp : password,
                                            API_KEYS.email : registerViewModel.email,
                                            API_KEYS.password: registerViewModel.password,
                                            API_KEYS.confirm_password : registerViewModel.confirm_password,
                                            API_KEYS.password_confirmation : registerViewModel.password_confirmation,
                                            API_KEYS.device_type : registerViewModel.device_type,
                                            API_KEYS.country_code : registerViewModel.country_code,
                                            API_KEYS.mobile_number : registerViewModel.mobile,
                                            API_KEYS.city : registerViewModel.city,
                                            API_KEYS.is_subscribed: registerViewModel.is_subscribed]
        
        if LocalDataManager.getInviteCode() != nil {
            params["referral_code"] = LocalDataManager.getInviteCode()
        }
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.Register(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data,let user = data.user{
                    Profile.save(user)
                    LocalDataManager.removeInviteCode()
                    LocalDataManager.setSocialUser(false)
                    complete()
                }
            })
        }
    }
    
    func resendOtpWS(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.name : registerViewModel.name,
                                            API_KEYS.email : registerViewModel.email,
                                            API_KEYS.country_code : registerViewModel.country_code,
                                            API_KEYS.reset : self.is_reset]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.sendOTP(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let message = response.message, response.code == 200{
                    INotifications.show(message: message)
                }
                complete()
            })
        }
    }
    
   
    
}
