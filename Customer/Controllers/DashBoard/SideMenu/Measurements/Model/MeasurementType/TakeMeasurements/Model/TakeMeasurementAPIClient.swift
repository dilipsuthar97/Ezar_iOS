//
//  LoginAPIClient.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

class TakeMeasurementAPIClient: NSObject {
    
    func SaveMeasurement(for params: NSMutableDictionary,
                         completionHandler: @escaping (TakeMeasurementRespose) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.savemeasurement)
            let params : Parameters = params as! Parameters
            
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let requestResponse = TakeMeasurementRespose(JSONString : response){
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
    
    func saveMeasureMentMulti(for params: NSMutableDictionary,
                              images : [MultipartFileJPEG]?,
                              completionHandler: @escaping (TakeMeasurementRespose) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            IProgessHUD.show()
            let url = URLs.findRepositories(API_URL.savemeasurement)
            let params : Parameters = params as! Parameters

            INetworkManager.multipartRequestJPEG(param: params,
                                             data: images,
                                             endPointUrl: url) { (response) in
                if let response = response {
                    if let takeMeasurementRespose = TakeMeasurementRespose(JSONString : response){
                        completionHandler(takeMeasurementRespose)
                    }
                }
            }
        }
    }
}

