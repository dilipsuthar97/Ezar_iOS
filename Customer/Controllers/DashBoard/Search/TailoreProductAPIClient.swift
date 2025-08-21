//
//  TailoreProductAPIClient.swift
//  Customer
//
//  Created by webwerks on 10/8/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class TailoreProductAPIClient: NSObject {
    
    func SearchProduct(for params: NSMutableDictionary,
                       completionHandler: @escaping (TailoreProductResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.homeproductsearch)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = TailoreProductResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
    
    func AddToWishlist(for params: NSMutableDictionary,
                       completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.addtowishlist)
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
