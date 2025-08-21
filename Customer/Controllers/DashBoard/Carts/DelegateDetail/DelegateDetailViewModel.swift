//
//  NearestDelegateViewModel.swift
//  Customer
//
//  Created by webwerks on 7/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class RequestDelegateModel : NSObject
{
    var latitude : String = ""
    var longitude : String = ""
    var delegate_id : Int = 0
    var customer_id : Int = Profile.loadProfile()?.id ?? 0
    var product_type : String = LocalDataManager.getUserSelection()
    var mobile_number : String = ""
    var countryCode : String = ""
    var customerAddress : String = ""
    var quote_id : String = ""
    var request_for : String = ""
    var request_information : String = ""
    var request_id : Int = 0
    var delegate_status : String = ""
    var productId : String = ""
    
    func setRequestFor(item_quote_id : String, type : String)
    {
        let request_for : [String : String] = ["item_quote_id": item_quote_id,  "type": type]
        self.request_for = COMMON_SETTING.json(from: request_for) ?? ""
    }
    
//    func setRequestFor(item_quote_id : String, fabric : String , measurement : String)
//    {
//        let request_for : [String : String] = ["item_quote_id": item_quote_id,  "fabric": fabric , "measurement" : measurement]
//        self.request_for = COMMON_SETTING.json(from: request_for) ?? ""
//    }
    
    func setRequestInformation(location_name : String, location_type : String, instructions: String)
    {
        let request_information : [String : String] = ["location_name":location_name,
                                                       "location_type":location_type,
                                                       "instructions":instructions]
        self.request_information = COMMON_SETTING.json(from: request_information) ?? ""
    }
}

class DelegateDetailViewModel: NSObject {

    let APIClient : DelegateDetailAPIClient!
    var delegateDetail : DelegateDetail? = nil
    var requestDelegateModel : RequestDelegateModel = RequestDelegateModel()
    var origin_lat : Double = 0.0
    var origin_lon : Double = 0.0
    var mobileNumber : String = ""
    var countryCode : String = ""
    var customer_id : Int = Profile.loadProfile()?.id ?? 0
    var reviewList          = [ReviewsList]()
    var status : String = ""
    var responseCode : Int = 0
    var request_Id : Int = 0
//    var reviewType          : String?
//    var review_id           : Any?
//    var upVote              : Int?

    init(apiClient: DelegateDetailAPIClient = DelegateDetailAPIClient()) {
        self.APIClient = apiClient
    }
    
    //NearestDelegateList Options
    func getDelegateDetail(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.delegate_id : requestDelegateModel.delegate_id,
                                            API_KEYS.latitude : requestDelegateModel.latitude,
                                            API_KEYS.longitude : requestDelegateModel.longitude,API_KEYS.customer_id : customer_id
                                            ]
        
        if request_Id != 0
        {
            params.removeAllObjects()
            params.addEntries(from: [API_KEYS.request_id : request_Id,
                                     API_KEYS.latitude : requestDelegateModel.latitude,
                                     API_KEYS.longitude : requestDelegateModel.longitude, API_KEYS.customer_id : customer_id
                                     ])
        }
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.DelegateDetail(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self?.delegateDetail = data
                    self?.request_Id = self?.status.uppercased() == "CANCELLED" ? 0 : self?.delegateDetail?.request_id ?? 0
                    if let reviewlist = data.reviewRating?.reviews?.list
                    {
                        self?.reviewList = reviewlist
                    }
                    complete()
                }
            })
        }
    }
    
    func sendDelegateRequest(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.latitude : requestDelegateModel.latitude,
                                            API_KEYS.longitude : requestDelegateModel.longitude,
                                            API_KEYS.delegate_id : requestDelegateModel.delegate_id,
                                            API_KEYS.customer_id : requestDelegateModel.customer_id,
                                            API_KEYS.mobile_number : requestDelegateModel.mobile_number,
                                            API_KEYS.country_code : requestDelegateModel.countryCode,
                                            API_KEYS.customer_address : requestDelegateModel.customerAddress,
                                            API_KEYS.request_for : requestDelegateModel.request_for,
                                            API_KEYS.request_information : requestDelegateModel.request_information]
        
        if request_Id != 0
        {
            params.removeAllObjects()
            params.addEntries(from: [API_KEYS.request_id : request_Id,
                                     API_KEYS.request_for : requestDelegateModel.request_for,
                                     API_KEYS.request_information : requestDelegateModel.request_information, API_KEYS.mobile_number : requestDelegateModel.mobile_number,
                                     API_KEYS.country_code : requestDelegateModel.countryCode,])
        }
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.DelegateRequest(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self?.delegateDetail = data
                    self?.request_Id = self?.delegateDetail?.request_id ?? 0
                    if self?.request_Id == 0
                    {
                        self?.request_Id = Int(self?.delegateDetail?.sRequest_id ?? "0") ?? 0
                    }
                }else{
                    INotifications.show(message: response.message ?? "")
                }
                self?.responseCode = response.code ?? 0
                complete()
            })
        }
    }
    
    func changeStatus(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.request_id : request_Id,
                                            API_KEYS.status : status]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ChangeStatus(for: params) { (response) in
                IProgessHUD.dismiss()
                if let message = response.message{
                    INotifications.show(message: message)
                }
                self.responseCode = response.code ?? 0
                complete()
            }
        }
    }
}

    
    
    
    

