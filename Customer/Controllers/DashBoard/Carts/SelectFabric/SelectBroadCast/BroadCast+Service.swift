//
//  BroadCastApiClient.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/29/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

class BroadCastApiClient: NSObject {
    
    func BroadCastList(for params: NSMutableDictionary, completionHandler: @escaping (BroadCastResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.broadCastList)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = BroadCastResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
    
    func BroadCastDeleteRequest(for params: NSMutableDictionary,
                                completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.deleteBroadCastRequest)
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

