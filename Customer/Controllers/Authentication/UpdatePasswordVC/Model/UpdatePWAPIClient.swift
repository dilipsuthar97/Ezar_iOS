//
//  ForgotPWAPIClient.swift
//  Customer
//
//  Created by Priyanka Jagtap on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class UpdatePWAPIClient: NSObject {
   
    func updatePasswordAPI(for params: NSMutableDictionary, completionHandler: @escaping (UpdatePWResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.customerResetPassword)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = UpdatePWResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
}
