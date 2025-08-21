//
//  BroadCastViewModel.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/29/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class BroadCastViewModel: NSObject {
    
    var broadCastListData  : BroadCastListData?
    
    let APIClient         : BroadCastApiClient
   
    var quoteID           : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var mobileNumber : String = ""
    var countryCode : String = ""
    var address : String = ""
    var product_id : String = ""
    var request_instruction : String = ""
    var request_for: String = ""
    var checkStatus  : Bool?
    
    var broadcast_id : Int = 0
    
    var requestDelegateModel : RequestDelegateModel = RequestDelegateModel()
    
    init(apiClient: BroadCastApiClient = BroadCastApiClient()) {
        self.APIClient = apiClient
    }
    
    
    
    //BroadCastList
    func getBroadCastList(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.quote_id : self.quoteID,API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,API_KEYS.request_for : requestDelegateModel.request_for,API_KEYS.latitude : latitude,API_KEYS.longitude : longitude ,API_KEYS.mobile_number : mobileNumber,API_KEYS.country_code : countryCode,API_KEYS.customer_address : address,API_KEYS.request_instruction : request_instruction ,API_KEYS.product_id : self.product_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.BroadCastList(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                self.checkStatus = response.status
                if let data = response.data
                {
                    self.broadCastListData = data
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                    complete()
                }else{
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
                
            })
        }
    }
    
    //DeleteBroadCastRequest
    func deleteBroadCastRequest(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.broadcast_id : self.broadcast_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.BroadCastDeleteRequest(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                self.checkStatus = response.status
                if let message = response.message{
                    INotifications.show(message: message)
                }
                 complete()
            })
        }
    }
}
