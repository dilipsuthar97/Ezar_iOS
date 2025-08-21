//
//  PaymentAPIClient.swift
//  Customer
//
//  Created by webwerks on 6/5/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class PaymentAPIClient: NSObject {

    func Payment(for params: NSMutableDictionary, completionHandler: @escaping (PlaceOrderResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.placeorder)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = PlaceOrderResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
    
    func PaymentMethodList(for params: NSMutableDictionary,
                           completionHandler: @escaping (PaymentMethodResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.paymentmethodlisting)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = PaymentMethodResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
}
