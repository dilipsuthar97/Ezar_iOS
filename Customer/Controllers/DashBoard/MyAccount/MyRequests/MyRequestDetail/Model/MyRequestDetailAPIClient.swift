//
//  NearestDelegateAPIClient.swift
//  Customer
//
//  Created by webwerks on 7/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class MyRequestDetailAPIClient: NSObject {

    func myRequestDetail(for params: NSMutableDictionary,
                         completionHandler: @escaping (DelegateDetailResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.customerRequestInformation)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = DelegateDetailResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
