//
//  OrderAPIClient.swift
//  Customer
//
//  Created by webwerks on 9/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class OrderDetailAPIClient: NSObject {
    
    func GetOrderDetails(for params: NSMutableDictionary,
                         completionHandler: @escaping (OrderDetailResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.getOrderDetails)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = OrderDetailResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
    
    func AddToCart(for params: NSMutableDictionary,
                   completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.addToCart)
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
    
    func cancelOrder(for params: NSMutableDictionary,
                     complete: @escaping isCompleted) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.cancelOrder)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if response != nil {
                    complete()
                }
            }
        }
    }
    
    func updateMeasurement(for params: NSMutableDictionary,
                           complete: @escaping isCompleted) {
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.updateMeasurement)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if response != nil {
                    complete()
                }
            }
        }
    }
}

