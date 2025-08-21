//
//  LoginViewModel.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire
import STPopup

//setup UserViewModel that inherites from NSObject
class LoginViewModel: NSObject {
    
    let APIClient : LoginAPIClient
    
    var email    : String = ""
    var password : String = ""
    var social_type : String = ""
    var name : String = ""
    var social_login_id : String = ""

    
    init(apiClient: LoginAPIClient = LoginAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Login
    func getLoginWS(complete: @escaping isCompleted) {
        
    let params : NSMutableDictionary = [API_KEYS.email : email, API_KEYS.password: password,API_KEYS.social_type : social_type]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.Login(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
            
                if let data = response.data{
                    Profile.save(data)
                    LocalDataManager.setSocialUser(false)
                    complete()
                }
            })
        }
    }
    func getSocialLogin(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.name : name, API_KEYS.email: email,API_KEYS.social_type : social_type, API_KEYS.social_login_id : social_login_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.Login(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data{
                    Profile.save(data)
                    LocalDataManager.setSocialUser(true)
                    complete()
                }else{
                    INotifications.show(message: "please_provide_email".localized)
                }
            })
        }
    }
}

