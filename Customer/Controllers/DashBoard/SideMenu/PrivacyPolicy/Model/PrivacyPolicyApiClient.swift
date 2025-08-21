//
//  PrivacyPolicyApiClient.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/22/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

class PrivacyPolicyApiClient: NSObject {
    
    func PrivacyPolicy(for params: NSMutableDictionary,
                       completionHandler: @escaping (PrivacyPolicyResponse) -> Void) {
        
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.cmspages)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = PrivacyPolicyResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}

