//
//  BodyFitApiClient.swift
//  EZAR
//
//  Created by abc on 31/08/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

class BodyFitApiClient: NSObject {
    
    func bodyFit(for params: NSMutableDictionary, completionHandler: @escaping (BodyFitResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.bodyFit)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = BodyFitResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
