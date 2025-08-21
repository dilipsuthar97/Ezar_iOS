//
//  ReturnAPIClient.swift
//  Customer
//
//  Created by webwerks on 11/1/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ReturnAPIClient: NSObject {
    
    func ReturnItem(for params: NSMutableDictionary,
                    completionHandler: @escaping (ReturnResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.orderReturn)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = ReturnResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}

