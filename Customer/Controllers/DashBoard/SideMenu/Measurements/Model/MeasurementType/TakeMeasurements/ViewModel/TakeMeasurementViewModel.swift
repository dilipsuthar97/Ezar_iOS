//
//  LoginViewModel.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject
class TakeMeasurementViewModel: NSObject {
    
    let APIClient : TakeMeasurementAPIClient
    var measurementDetailModel : MeasurementDetailViewModel?
    var measurements            : NSMutableArray = NSMutableArray()
    //let detailArray : NSMutableArray = NSMutableArray()
    var customer_id             : Int = 0
    var dropDownTxt             : String = ""
    var title = ""
    var bodyHeight = ""
    var bodyWeight = ""
    var measurementID = ""
    var productId : String = ""
    
    var bodyImage : [MultipartFileJPEG]? = nil
    
    init(apiClient: TakeMeasurementAPIClient = TakeMeasurementAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Save Measurement
    func saveMeasurement(complete: @escaping isCompleted)
    {
        let jsonString : String = COMMON_SETTING.json(from: measurements) ?? ""
        let params : NSMutableDictionary = NSMutableDictionary()
        params.addEntries(from: [API_KEYS.product_id : measurementDetailModel?.product_id ?? "",
                                 API_KEYS.customer_id : customer_id,
                                 "fit_type":measurementDetailModel?.fit_type ?? 0,
                                 API_KEYS.measurement_type : measurementDetailModel?.measurementType ?? ""])
        params.addEntries(from: [API_KEYS.title : measurementDetailModel?.measurementName ?? "",
                                 API_KEYS.height : measurementDetailModel?.height ?? "",
                                 API_KEYS.weight : measurementDetailModel?.weight ?? "",
                                 API_KEYS.measure_by : "self"])
        params.addEntries(from: [API_KEYS.collar : measurementDetailModel?.collarSize ?? "",
                                 API_KEYS.selected_type : measurementDetailModel?.selected_type ?? "",
                                 API_KEYS.measurements : jsonString])
        
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.SaveMeasurement(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self?.measurementDetailModel?.measurement_id = data.measurement_id
                    complete()
                }
            })
        }
    }
    
    func updateMeasurementForCartProduct(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.measurement_id : self.measurementDetailModel?.measurement_id ?? "",
                                            API_KEYS.item_quote_id: self.measurementDetailModel?.item_quote_id ?? ""]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.UpdateMeasurement(for: params, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    
    //Save Measurement
    func saveMeasurementMultipart(complete: @escaping isCompleted)
    {
        let jsonString : String = COMMON_SETTING.json(from: measurements) ?? ""
        let params : NSMutableDictionary = NSMutableDictionary()
        
        if COMMON_SETTING.productIDScanBody == 0{
            productId = ""
        }else{
            productId = String(COMMON_SETTING.productIDScanBody)
        }
        
        params.addEntries(from: [API_KEYS.product_id : productId ,
                                 API_KEYS.customer_id : customer_id,
                                 API_KEYS.measurement_type :  ""])
        params.addEntries(from: [API_KEYS.title : title,
                                 API_KEYS.height : bodyHeight,
                                 API_KEYS.weight : bodyWeight,
                                 API_KEYS.measure_by : "Nettelo"])
        params.addEntries(from: [API_KEYS.collar : "",
                                 API_KEYS.selected_type : COMMON_SETTING.selectType,
                                 API_KEYS.measurements : jsonString,
                                 API_KEYS.measurement_id : measurementID])
        
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.saveMeasureMentMulti(for: params, images: bodyImage, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self.measurementDetailModel?.measurement_id = data.measurement_id
                    self.measurementID = data.measurement_id
                    complete()
                }
            })
        }
    }
    
    func updateMeasurementForCartProductNew(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.measurement_id : self.measurementID,
                                            API_KEYS.item_quote_id: COMMON_SETTING.itemQuoteID]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.UpdateMeasurement(for: params, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    
}

