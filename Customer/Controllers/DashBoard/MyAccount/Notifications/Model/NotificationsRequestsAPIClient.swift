//
//  LoginAPIClient.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

class NotificationsRequestsAPIClient: NSObject {
    
    func notificationsListAPI(for params: NSMutableDictionary, completionHandler: @escaping (NotificationsResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.customerNotificationListURL)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let baseResponse = NotificationsResponse(JSONString : response){
                        completionHandler(baseResponse)
                    }
                }
            }
        }
    }
}
