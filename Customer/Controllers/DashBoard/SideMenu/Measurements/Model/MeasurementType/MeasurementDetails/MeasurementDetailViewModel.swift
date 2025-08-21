//
//  MeasurementDetailViewModel.swift
//  Customer
//
//  Created by webwerks on 6/4/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class MeasurementDetailViewModel: NSObject {
    
    let APIClient               : MeasurementDetailAPIClient
    var measuremetTemplate       : MeasurementTemplate?
    var product_id              : Int = 0
    var item_quote_id           : String = ""
    var measurementType         : String = ""
    
    var measurementName         : String = ""
    var height                  : String = ""
    var weight                  : String = ""
    var collarSize              : String = ""
    var selected_type           : String = "Perfect"
   
    var measurement_id          : String = ""
    var model_type             : Int = 0
    var fit_type             : Int = 0

    init(apiClient: MeasurementDetailAPIClient = MeasurementDetailAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Measurement
    func getMeasurementOptions(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.product_id : product_id,
                                            API_KEYS.measurement_type : measurementType
            ,API_KEYS.model_type : model_type]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.Measurement(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self?.measuremetTemplate = data
                    complete()
                }
            })
        }
    }
}
