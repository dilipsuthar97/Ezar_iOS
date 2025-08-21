//
//  TermsConditionScannerApiClient.swift
//  EZAR
//
//  Created by abc on 16/07/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

class TermsConditionScannerApiClient: NSObject {
    
    func termsConditionScanner(for params: NSMutableDictionary,
                               completionHandler: @escaping (TermsConditionScannerResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.termsConditionScanner)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = TermsConditionScannerResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
