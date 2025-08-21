//
//  EditAddressAPIClient.swift
//  Customer
//
//  Created by webwerks on 5/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class EditAddressAPIClient: NSObject {

    func ShippingMethods(for params: NSMutableDictionary,
                         completionHandler: @escaping (EditAddressResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.availableShippingMethods)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = EditAddressResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
}
