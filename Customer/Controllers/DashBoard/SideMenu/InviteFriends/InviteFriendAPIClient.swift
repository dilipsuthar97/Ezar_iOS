//
//  InviteFriendAPIClient.swift
//  Customer
//
//  Created by webwerks on 12/12/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class InviteFriendAPIClient: NSObject {

    func InviteFriends(for params: NSMutableDictionary,
                       completionHandler: @escaping (InviteFriendRespose) -> Void) {
        

        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.invitefriends)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = InviteFriendRespose(JSONString : response){
                        requestResponse.data
                        
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
