//
//  PrivacyPolicyViewModel.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/22/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class PrivacyPolicyViewModel: NSObject {
    
    var privacyPolicy  : [PrivayPolicy] = [PrivayPolicy]()
    
    let APIClient         : PrivacyPolicyApiClient
    var delegate_id            : Int = 0
    
    init(apiClient: PrivacyPolicyApiClient = PrivacyPolicyApiClient()) {
        self.APIClient = apiClient
    }
    
    //PrivacyPolicy
    func getPrivacyPolicy(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.identifier : "privacy-policy"]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.PrivacyPolicy(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data?.privayPolicy, data.count > 0
                {
                    self.privacyPolicy = data
                    complete()
                }else{
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
            })
        }
    }
}

