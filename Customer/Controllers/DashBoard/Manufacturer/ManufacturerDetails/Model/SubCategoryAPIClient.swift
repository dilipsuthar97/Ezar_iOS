//
//  SubCategoryAPIClient.swift
//  Customer
//
//  Created by Shrikant Kanakatti on 5/9/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

class SubCategoryAPIClient: NSObject {
    
    func SubCategoryDetails(for params: NSMutableDictionary,
                            completionHandler: @escaping (SubCategoryResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.subCategoryListing)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = SubCategoryResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
    
    func CategoryProductList(for params: NSMutableDictionary,
                             completionHandler: @escaping (SubCategoryResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.catalogproducts)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = SubCategoryResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
}
