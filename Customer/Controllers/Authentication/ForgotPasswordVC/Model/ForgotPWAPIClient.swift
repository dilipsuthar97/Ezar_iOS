//
//  ForgotPWAPIClient.swift
//  Customer
//
//  Created by Priyanka Jagtap on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPWAPIClient: NSObject {
   
    func forgotPasswordAPI(for params: NSMutableDictionary, completionHandler: @escaping (ForgotPWResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.forgetPassword)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = ForgotPWResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
}
