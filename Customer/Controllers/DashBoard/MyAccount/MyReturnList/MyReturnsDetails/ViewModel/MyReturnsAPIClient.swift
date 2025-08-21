//
//  MyReturnsAPIClient.swift
//  Customer
//
//  Created by webwerks on 11/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class MyReturnsAPIClient: NSObject {

    func MyReturnDetails(for params: NSMutableDictionary,
                         completionHandler: @escaping (MyReturnsResponse) -> Void) {
      
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.returndetails)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = MyReturnsResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
    
    func SubmitComment(for params: NSMutableDictionary,
                       completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.requestreply)
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
