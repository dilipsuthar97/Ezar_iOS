//
//  MyTailorMeasurementViewModel.swift
//  EZAR
//
//  Created by The Appineers on 23/02/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MyTailorMeasurementViewModel: NSObject
{
    let APIClient : MyTailorMeasurementAPIClient
    
    var message                         : String    = ""
    var product_id                      : Int = 0
    var customer_id                     : Int       = 0
    var measurement_id                  : String    = ""
    var item_quote_id                   : String    = ""
    var note                            : String    = ""
    
    init(apiClient: MyTailorMeasurementAPIClient = MyTailorMeasurementAPIClient()) {
        self.APIClient = apiClient
    }
    
    func updateMeasurementForCartProduct(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.measurement_id : measurement_id,
                                            API_KEYS.item_quote_id: item_quote_id,
                                            API_KEYS.measurement_note: note]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.UpdateMeasurement(for: params, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    
}
