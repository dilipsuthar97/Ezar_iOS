//
//  ReturnViewModel.swift
//  Customer
//
//  Created by webwerks on 11/1/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ReturnViewModel: NSObject {
    let APIClient : ReturnAPIClient
   
    //Request Parameters --
    var order_id : Int = 0
    var order_incremental_id : Int = 0
    var message : String = ""
    var order_items : NSMutableDictionary = NSMutableDictionary()
    
    //Response Check --
    var isResponseSuccess : Bool = false
    
    init(apiClient: ReturnAPIClient = ReturnAPIClient()) {
        self.APIClient = apiClient
    }
    
    func returnItem(complete: @escaping isCompleted)
    {
        let order_itemsString : String = COMMON_SETTING.json(from: order_items) ?? ""
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.order_id : self.order_id,
                                            API_KEYS.order_incremental_id : self.order_incremental_id,
                                            API_KEYS.message : self.message,
                                            API_KEYS.order_items : order_itemsString]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.ReturnItem(for: params) { (response) in
                IProgessHUD.dismiss()
                INotifications.show(message: response.message ?? "")
                if response.code == 200
                {
                    self.isResponseSuccess = true
                }
                complete()
            }
        }
    }
    
}
