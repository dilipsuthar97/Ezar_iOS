//
//  SaveAddressAPIClient.swift
//  Customer
//
//  Created by webwerks on 9/26/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class SaveAddressAPIClient: NSObject {
    func GetAddress(for params: NSMutableDictionary,
                    completionHandler: @escaping (SaveAddressResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.getaddress)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = SaveAddressResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
    
    func RemoveAddress(for params: NSMutableDictionary,
                       completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.removeaddress)
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
