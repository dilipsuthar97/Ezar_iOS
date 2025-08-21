//
//  ScanBodyApiClient.swift
//  EZAR
//
//  Created by abc on 15/07/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

class ScanBodyApiClient: NSObject {
    
    func scanBody(for params: NSMutableDictionary,
                  completionHandler: @escaping (ScanBodyResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.bodymeasurementscanner)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = ScanBodyResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
