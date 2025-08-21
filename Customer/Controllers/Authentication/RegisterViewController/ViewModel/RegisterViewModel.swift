//
//  RegisterViewModel.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject
class RegisterViewModel: NSObject {
    
    let APIClient : RegisterAPIClient
    var name                    : String = ""
    var email                   : String = ""
    var password                : String = ""
    var confirm_password        : String = ""
    var password_confirmation   : String = ""
    var device_type             : String = "iphone"
    var country_code            : String = ""
    var mobile                  : String = ""
    var city                    : String = ""
    var is_subscribed           : Int = 0
    var social_type : String = ""
    var social_login_id : String = ""
  
    init(apiClient: RegisterAPIClient = RegisterAPIClient()) {
        self.APIClient = apiClient
    }
    
    func sendOtpWS(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.name : name,
                                            API_KEYS.email : email,
                                            API_KEYS.country_code : country_code,
                                            API_KEYS.mobile_number : mobile]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.sendOTP(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let message = response.message, response.code == 200{
                    INotifications.show(message: message)
                    complete()
                }
            })
        }
    }
    
    //Register
    func getRegisterWS(complete: @escaping isCompleted) {
       
    let params : NSMutableDictionary = [API_KEYS.name : name,
                                        API_KEYS.email : email,
                                        API_KEYS.password: password,
                                        API_KEYS.confirm_password : confirm_password,
                                        API_KEYS.password_confirmation : password_confirmation,
                                        API_KEYS.device_type : device_type,
                                        API_KEYS.country_code : country_code,
                                        API_KEYS.mobile_number : mobile,
                                        API_KEYS.city : city,
                                        API_KEYS.is_subscribed: is_subscribed]
        
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
    
    func getSocialRegister(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.name : name, API_KEYS.email: email,API_KEYS.social_type : social_type, API_KEYS.social_login_id : social_login_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.Login(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data{
                    Profile.save(data)
                    LocalDataManager.setSocialUser(true)
                    complete()
                }
            })
        }
    }
}
