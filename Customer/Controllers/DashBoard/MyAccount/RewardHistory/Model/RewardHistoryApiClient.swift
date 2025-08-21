//
//  RewardHistoryApiClient.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/22/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

class RewardHistoryApiClient: NSObject {
    
    func RewardHistory(for params: NSMutableDictionary, completionHandler: @escaping (RewardHistoryResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.rewardHistory)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = RewardHistoryResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}

