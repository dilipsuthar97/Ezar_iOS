//
//  LoginViewModel.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class SettingsViewModel: NSObject {
    
    let APIClient : SettingsAPIClient
    var old_password    : String = ""
    var new_password : String = ""
    var email : String = ""
   
    init(apiClient: SettingsAPIClient = SettingsAPIClient()) {
        self.APIClient = apiClient
    }
    
    //MARK:- Change Password
    
    func changePassword(complete:  @escaping (ChangePasswordResponse) -> Void) {
        
        let params : NSMutableDictionary = [API_KEYS.email : email,  API_KEYS.old_password : old_password, API_KEYS.new_password: new_password]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.ChangePassword(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                complete(response)
            })
        }
    }
}
