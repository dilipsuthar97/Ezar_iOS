//
//  OTPAPIClient.swift
//  Customer
//
//  Created by Priyanka Jagtap on 14/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class OTPAPIClient: NSObject {
   
    func Register(for params: NSMutableDictionary, completionHandler: @escaping (RegisterResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.register)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = RegisterResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
    
    func sendOTP(for params: NSMutableDictionary,
                 completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.sendotp)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = BaseResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
}
