//
//  FavoriteAPIClient.swift
//  Customer
//
//  Created by webwerks on 10/4/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class FavoriteAPIClient: NSObject {
    func GetWishList(for params: NSMutableDictionary,
                     completionHandler: @escaping (FavoriteResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.getwishlist)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = FavoriteResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
    
    func RemoveFromWishList(for params: NSMutableDictionary,
                            completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.removefromwishlist)
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
    
    func ProductDetails(for params: NSMutableDictionary,
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
}
