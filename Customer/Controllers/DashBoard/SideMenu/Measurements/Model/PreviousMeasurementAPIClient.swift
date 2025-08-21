//
//  PreviousMeasurementAPIClient.swift
//  Customer
//
//  Created by webwerks on 5/25/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class PreviousMeasurementAPIClient: NSObject {
    
    func PreviousMeasurement(for params: NSMutableDictionary,
                             completionHandler: @escaping (PreviousMeasurementResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.previousmeasurement)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = PreviousMeasurementResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }

    func UpdateMeasurement(for params: NSMutableDictionary,
                           complete: @escaping isCompleted) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.updatemeasurement)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if response != nil {
                    complete()
                }
            }
        }
    }
    
    func deleteMeasurement(id: String, complete: @escaping isCompleted) {
        if IConnectivityService.isConnectedToInternet() {
            IProgessHUD.show()
            let endPoint =  API_URL.deletemeasurement + "?id=\(id)"
            let url = URLs.findRepositories(endPoint)
         
            INetworkManager.performRequest(url: url, method: .delete) { (response) in
                if response != nil {
                    complete()
                }
            }
        }
    }
    
    func GetMeasurement(for params: NSMutableDictionary,
                        completionHandler: @escaping (PreviousMeasurementResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.getmeasurements)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = PreviousMeasurementResponse(JSONString : response){
                        completionHandler(requestResponse)
                    }
                }
            }
        }
    }
}
