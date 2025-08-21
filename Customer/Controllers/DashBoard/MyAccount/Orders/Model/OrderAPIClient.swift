//
//  OrderAPIClient.swift
//  Customer
//
//  Created by webwerks on 9/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class OrderAPIClient: NSObject {
    
    func GetOrders(for params: NSMutableDictionary,
                   completionHandler: @escaping (OrderResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.getorders)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = OrderResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
    
    func GetAllOrdersAPI(for params: NSMutableDictionary,
                         completionHandler: @escaping (OrderResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.getallorders)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = OrderResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
