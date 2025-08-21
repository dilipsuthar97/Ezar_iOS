//
//  MeasurementDetailAPIClient.swift
//  Customer
//
//  Created by webwerks on 6/4/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class MeasurementDetailAPIClient: NSObject {

    func Measurement(for params: NSMutableDictionary,
                     completionHandler: @escaping (MeasurementDetailResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.measurementoptions)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = MeasurementDetailResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
