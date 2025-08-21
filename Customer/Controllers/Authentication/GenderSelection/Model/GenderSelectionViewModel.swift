//
//  GenderSelectionViewModel.swift
//  Customer
//
//  Created by webwerks on 10/17/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class GenderSelectionViewModel: NSObject
{
    let APIClient               : GenderSelectionAPIClient
    
    init(apiClient: GenderSelectionAPIClient = GenderSelectionAPIClient()) {
        self.APIClient = apiClient
    }
    
    func getRegisterDeviceToken(_ complete: @escaping isCompleted)
    {
        let customerId = Profile.loadProfile()?.id ?? 0
        let deviceToken = LocalDataManager.getDeviceToken()
        let deviceTokenType = "ios"
        
        let params : NSMutableDictionary = [API_KEYS.customer_id : customerId,
                                            API_KEYS.device_token : deviceToken,
                                            API_KEYS.device_token_type : deviceTokenType]
        
        
        if COMMON_SETTING.isConnectedToInternet() {
            
            APIClient.RegisterDeviceToken(for: params) { (response) in
                if let status = response.code, status == 200{
                    LocalDataManager.setDeviceTokenRegister(true)
                }
                complete()
            }
        }
    }
}
