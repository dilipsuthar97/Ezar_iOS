//
//  MyTailorMeasurementAPIClient.swift
//  EZAR
//
//  Created by The Appineers on 23/02/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import Foundation

import UIKit
import Alamofire

class MyTailorMeasurementAPIClient: NSObject {
    
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
}

