//
//  ForgotPWViewModel.swift
//  Customer
//
//  Created by Priyanka Jagtap on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MessageViewModel: NSObject {
    //setup UserViewModel that inherites from NSObject
    
        let APIClient : MessageAPIClient
        
        var message        : String = ""
        var delegate_id     : Int    = 0
        var customer_id     : Int    = 0
        var isCustomer      : Int    = 0

        init(apiClient: MessageAPIClient = MessageAPIClient()) {
            self.APIClient = apiClient
        }
        
    //MARK:- Forgot password
    
    func sendMessageWS(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.message : message,API_KEYS.customer_id : customer_id , API_KEYS.delegate_id : delegate_id , API_KEYS.is_customer : isCustomer]
        
            if COMMON_SETTING.isConnectedToInternet() {
                
                IProgessHUD.show()

                APIClient.sendMessageWSAPI(for: params, completionHandler: { (response) in
                    IProgessHUD.dismiss()
                    INotifications.show(message: response.message ?? "")
                    complete()
                })
            }
        }
}
