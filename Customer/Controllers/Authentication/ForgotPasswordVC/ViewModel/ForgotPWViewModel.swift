//
//  ForgotPWViewModel.swift
//  Customer
//
//  Created by Priyanka Jagtap on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ForgotPWViewModel: NSObject {
    //setup UserViewModel that inherites from NSObject
    
        let APIClient : ForgotPWAPIClient
        
        var email    : String = ""
    
        init(apiClient: ForgotPWAPIClient = ForgotPWAPIClient()) {
            self.APIClient = apiClient
        }
        
    //MARK:- Forgot password
    
    func getForgotPasswordWS(complete: @escaping (ForgotPWResponse) -> Void) {
        
        let params : NSMutableDictionary = [API_KEYS.email : email]
        
            if COMMON_SETTING.isConnectedToInternet() {
                
                IProgessHUD.show()

                APIClient.forgotPasswordAPI(for: params, completionHandler: { (response) in
                    IProgessHUD.dismiss()
                    complete(response)
                })
            }
        }
}
