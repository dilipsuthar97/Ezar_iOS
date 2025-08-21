//
//  ProfileAPIClient.swift
//  Customer
//
//  Created by webwerks on 5/18/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ProfileAPIClient: NSObject {
    
    func MyAccountDetails(for params: NSMutableDictionary,
                          completionHandler: @escaping (ProfileResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.myaccount)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = ProfileResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
}
