//
//  ReviewFeedbackAPIClient.swift
//  Customer
//
//  Created by webwerks on 9/20/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ReviewFeedbackAPIClient: NSObject {
    func SubmitReview(for params: NSMutableDictionary,
                      completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.reviews_add)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = BaseResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
