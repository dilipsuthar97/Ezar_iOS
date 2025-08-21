//
//  MeasurementTypeAPIClient.swift
//  Customer
//
//  Created by webwerks on 6/6/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class MeasurementTypeAPIClient: NSObject {
    
    func Measurement(for params: NSMutableDictionary,
                     completionHandler: @escaping (MeasurementTypeResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.measurements)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = MeasurementTypeResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
