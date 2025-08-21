//
//  LoginAPIClient.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

class MyRequestsAPIClient: NSObject {
    
    func myRequestList(for params: NSMutableDictionary,
                       completionHandler: @escaping (MyRequestResponse) -> Void,
                       complete: @escaping isCompleted) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.customerRequest)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = MyRequestResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                } else {
                    complete()
                }
            }
        }
    }
    
    func ChangeStatus(for params: NSMutableDictionary,
                      completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.changeRequestStatus)
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
