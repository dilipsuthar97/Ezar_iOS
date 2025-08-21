//
//  PreviousMeasurementViewModel.swift
//  Customer
//
//  Created by webwerks on 5/25/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class PreviousviewMeasurementViewModel: NSObject
{
    let APIClient : PreviousMeasurementAPIClient
    
    var previousMeasurementList         : [PreviousMeasurementData]?
    var message                         : String    = ""
    
    var product_id                      : Int = 0
    var customer_id                     : Int       = 0
    var measurement_id                  : String    = ""
    var item_quote_id                   : String    = ""
    var note                            : String = ""
    
    init(apiClient: PreviousMeasurementAPIClient = PreviousMeasurementAPIClient()) {
        self.APIClient = apiClient
    }
    
    func getPreviousMeasurement(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.product_id : product_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.PreviousMeasurement(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data,data.count > 0
                {
                    self?.previousMeasurementList = data
                    self?.message = response.message ?? ""
                    complete()
                }else{
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
            })
        }
    }
    
    func updateMeasurementForCartProduct(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.measurement_id : measurement_id,
                                            API_KEYS.item_quote_id: item_quote_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.UpdateMeasurement(for: params, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    
    func deleteMeasurement(id: String, complete: @escaping isCompleted) {
        APIClient.deleteMeasurement(id: id,
                                    complete: {
            IProgessHUD.dismiss()
            complete()
        })
    }
    
    func getMeasurement(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.GetMeasurement(for: params) { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data,data.count > 0
                {
                    self?.previousMeasurementList = data
                    self?.message = response.message ?? ""
                    complete()
                }else{
                    INotifications.show(message: TITLE.customer_no_measurement.localized)
                }
            }
        }
    }
}
