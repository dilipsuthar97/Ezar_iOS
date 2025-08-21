//
//  ProductsAPIClient.swift
//  Customer
//
//  Created by webwerks on 6/28/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ProductsAPIClient: NSObject {

    func TailoreCategoryProducts(for params: NSMutableDictionary,
                                 completionHandler: @escaping (ProductsResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.tailorCatalogProducts)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = ProductsResponse(JSONString : response){
                        completionHandler(requestResponse)
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
                    if let requestResponse = BaseResponse(JSONString : response){
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
}
