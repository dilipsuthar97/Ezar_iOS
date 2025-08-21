//
//  LoginAPIClient.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

class HomeRequestsAPIClient: NSObject {
    
    //MARK: - Home Category API
    func homeCategory(for params: NSMutableDictionary,
                      completionHandler: @escaping (HomeResponse) -> Void,
                      complete: @escaping isCompleted) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.category)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let homeResponse = HomeResponse(JSONString : response){
                        completionHandler(homeResponse)
                    }
                } else {
                    complete()
                }
            }
        }
    }
    
    //MARK: - Explore More Product
    func homeExploreMoreProduct(for params: NSMutableDictionary,
                                completionHandler: @escaping (HomeResponse) -> Void,
                                complete: @escaping isCompleted) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.exploreCategory)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let homeResponse = HomeResponse(JSONString : response){
                        completionHandler(homeResponse)
                    }
                } else {
                    complete()
                }
            }
        }
    }
    
    //MARK: - Home promotions
    func homePromotions(for params: NSMutableDictionary,
                        completionHandler: @escaping (HomePromotionResponse) -> Void,
                        complete: @escaping isCompleted) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.promotions)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let homeResponse = HomePromotionResponse(JSONString : response){
                        completionHandler(homeResponse)
                    }
                } else {
                    complete()
                }
            }
        }
    }
    
    //MARK: - Offer Home promotions
    func homePromotionsOffer(for params: NSMutableDictionary,
                             completionHandler: @escaping (HomePromotionResponse) -> Void,
                             complete: @escaping isCompleted) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.promotions)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let baseResponse = HomePromotionResponse(JSONString: response) {
                        completionHandler(baseResponse)
                    }
                } else {
                    complete()
                }
            }
        }
    }
    
    
    func RegisterDeviceToken(for params: NSMutableDictionary,
                             completionHandler: @escaping (BaseResponse) -> Void) {
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.customerTokenUpdate)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let baseResponse = BaseResponse(JSONString: response) {
                        completionHandler(baseResponse)
                    }
                }
            }
        }
    }
}
