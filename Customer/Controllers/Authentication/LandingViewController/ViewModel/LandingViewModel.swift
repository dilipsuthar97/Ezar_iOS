//
//  LandingViewModel.swift
//  EZAR
//
//  Created by The Appineers on 22/03/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

class LandingViewModel: NSObject
{
    let APIClient : LandingAPIClient
    
    var configurationDetails            : ConfigurationData?
    var message                         : String    = ""
    
    var product_id                      : Int = 0
    var customer_id                     : Int       = 0
    var measurement_id                  : String    = ""
    var item_quote_id                   : String    = ""
    var note                            : String = ""
    
    init(apiClient: LandingAPIClient = LandingAPIClient()) {
        self.APIClient = apiClient
    }
    
    func getConfigurationDetails(complete: @escaping isCompleted) {
        APIClient.ApplicationConfiguration(completionHandler: { [weak self] (response) in
            if let data = response.data {
                self?.configurationDetails = data
                complete()
            } else {
                if let message = response.message {
                    INotifications.show(message: message)
                }
            }
        })
    }
}
