//
//  LoginAPIClient.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

class ReviewRequestAPIClient: NSObject {
    func ReviewAndFeedback(for params: NSMutableDictionary,
                           completionHandler: @escaping (ReviewResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.reviewsAndFeedback)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = ReviewResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
    
    func ReviewAndFeedbackPagination(for params: NSMutableDictionary,
                                     completionHandler: @escaping (ReviewResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.reviewsandfeedbackpagination)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = ReviewResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
