//
//  MeasurementTypeModel.swift
//  Customer
//
//  Created by webwerks on 6/6/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class MeasurementTypeModel: NSObject {
    let APIClient           : MeasurementTypeAPIClient
    var measurementList  : [MesurementItems] = []
    var product_id           : Int = 0
    var item_quote_id        : String = ""
    
    init(apiClient: MeasurementTypeAPIClient = MeasurementTypeAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Measurement
    func getMeasurement(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.product_id : product_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.Measurement(for: params, completionHandler:  { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    if let data = data.items{
                         self?.measurementList = data
                    }
                    if self?.measurementList.count ?? 0 == 0 {
                        INotifications.show(message: TITLE.customer_measurement_option.localized)
                    }
                    complete()
                }
            })
        }
    }
}

