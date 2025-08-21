//
//  ForgotPWViewModel.swift
//  Customer
//
//  Created by Priyanka Jagtap on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class UpdatePWViewModel: NSObject {
    //setup UserViewModel that inherites from NSObject
    
        let APIClient : UpdatePWAPIClient
        
     var newPassword    : String = ""
     var confirmPassword    : String = ""
     var customer_id    : Int = 0

        init(apiClient: UpdatePWAPIClient = UpdatePWAPIClient()) {
            self.APIClient = apiClient
        }
        
    //MARK:- Forgot password
    
    func resetPasswordWS(complete: @escaping (UpdatePWResponse) -> Void) {
        
        let params : NSMutableDictionary = [API_KEYS.new_password : newPassword, API_KEYS.confirm_password : confirmPassword,
            API_KEYS.customer_id : customer_id]
        
            if COMMON_SETTING.isConnectedToInternet() {
                
                IProgessHUD.show()

                APIClient.updatePasswordAPI(for: params, completionHandler: { (response) in
                    IProgessHUD.dismiss()
                    complete(response)
                })
            }
        }
}
