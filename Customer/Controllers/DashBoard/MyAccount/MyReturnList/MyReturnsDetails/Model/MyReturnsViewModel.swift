//
//  MyReturnsViewModel.swift
//  Customer
//
//  Created by webwerks on 11/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class MyReturnsViewModel: NSObject
{
    let APIClient : MyReturnsAPIClient
    var returnDetails : ReturnDetails?
    var returnItem : ReturnItems? = nil
    var responseCode : Int = 0
    var message : String = ""
    
    init(apiClient: MyReturnsAPIClient = MyReturnsAPIClient()) {
        self.APIClient = apiClient
    }
    
    func returnDetails(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.request_id : returnItem?.request_id ?? 0]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.MyReturnDetails(for: params) { (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self.returnDetails = data
                }
                self.responseCode = response.code ?? 0
                complete()
            }
        }
    }
    
    func submitComment(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.request_id : returnItem?.request_id ?? 0,
                                            API_KEYS.order_incremental_id : self.returnDetails?.order_incremental_id ?? "0",
                                            API_KEYS.message : message]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.SubmitComment(for: params) { (response) in
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
