//
//  GenderSelectionAPIClient.swift
//  Customer
//
//  Created by webwerks on 10/17/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class GenderSelectionAPIClient: NSObject
{
    func RegisterDeviceToken(for params: NSMutableDictionary,
                             completionHandler: @escaping (BaseResponse) -> Void) {
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.customerTokenUpdate)
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
