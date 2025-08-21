//
//  SearchAPIClient.swift
//  Customer
//
//  Created by webwerks on 5/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class SearchAPIClient: NSObject {
    
    func Search(for params: NSMutableDictionary, completionHandler: @escaping (SearchResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.searchSeller)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = SearchResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
}
