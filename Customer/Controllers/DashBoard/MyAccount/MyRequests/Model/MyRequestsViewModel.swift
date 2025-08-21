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

class MyRequestsViewModel: NSObject {
    
    let APIClient : MyRequestsAPIClient
    var customer_id           : Int = 0
    var requestList           : [MyRequestList] = [MyRequestList]()
    var request_id : Int = 0
    var status : String = ""

   
    init(apiClient: MyRequestsAPIClient = MyRequestsAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Home Category
    func getMyRequest(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.customer_id : self.customer_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.myRequestList(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
            if let data = response.data,data.count > 0{
                self.requestList = data
            }else{
                if let message = response.message{
                    INotifications.show(message: message)
                }
            }
            complete()
            }, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    
    func changeStatus(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.request_id : request_id,
                                            API_KEYS.status : status]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ChangeStatus(for: params) { (response) in
                IProgessHUD.dismiss()
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            }
        }
    }
}
