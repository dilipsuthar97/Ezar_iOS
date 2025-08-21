//
//  TermsAndConditionApiClient.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/3/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

class TermsAndConditionApiClient: NSObject {
    
    func TermsAndCondition(for params: NSMutableDictionary,
                           completionHandler: @escaping (TermsAndConditionResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.cmspages)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = TermsAndConditionResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}

