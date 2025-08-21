//
// EditProfileViewModel.swift
//  Customer
//
//  Created by Priyanka Jagtap on 09/10/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject
class ApplyCoupenViewModel: NSObject {
    
    let APIClient : ApplyCoupenAPIClient
 
    var couponCode : String = ""
    var customerId : Int = 0
  
    
    init(apiClient: ApplyCoupenAPIClient = ApplyCoupenAPIClient()) {
        self.APIClient = apiClient
    }
    
    func applyCoupenWS(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.message : couponCode,API_KEYS.customer_id : customerId]
        
        if COMMON_SETTING.isConnectedToInternet() {
            
            IProgessHUD.show()
            
            APIClient.applyCouponAPI(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                INotifications.show(message: response.message ?? "")
                complete()
            })
        }
    }
   
}
