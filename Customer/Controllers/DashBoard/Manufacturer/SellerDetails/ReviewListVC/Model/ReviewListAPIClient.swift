//
//  ReviewListAPIClient.swift
//  Customer
//
//  Created by Priyanka Jagtap on 31/05/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ReviewListAPIClient: NSObject {
  
    //All Reviews
    func SellerAllReviews(for params: NSMutableDictionary,
                          completionHandler: @escaping (SellerAllReviewResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.allReviews)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = SellerAllReviewResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
    
    func ReviewLikeDislike(for params: NSMutableDictionary,
                           completionHandler: @escaping (BaseResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.reviewslikedislike)
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
