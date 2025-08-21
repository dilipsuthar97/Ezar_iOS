//
//  MyReturnListAPIClient.swift
//  Customer
//
//  Created by webwerks on 11/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class MyReturnListAPIClient: NSObject {
    
    func MyReturnList(for params: NSMutableDictionary,
                      completionHandler: @escaping (MyReturnListResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.myReturn)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = MyReturnListResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
