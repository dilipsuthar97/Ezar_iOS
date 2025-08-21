//
//  EditProfileAPIClient.swift
//  Customer
//
//  Created by Priyanka Jagtap on 09/10/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ApplyCoupenAPIClient: NSObject {
   
    func applyCouponAPI(for params: NSMutableDictionary,
                        completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.sendMessage)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = BaseResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
