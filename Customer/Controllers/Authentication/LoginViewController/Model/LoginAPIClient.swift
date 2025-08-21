//
//  LoginAPIClient.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

class LoginAPIClient: NSObject {
    
    
    func Login(for params: NSMutableDictionary, completionHandler: @escaping (LoginResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.Login)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let loginResponse = LoginResponse(JSONString : response){
                    completionHandler(loginResponse)
                   }
                }
            }
        }
    }
}
