//
//  MyReturnListViewModel.swift
//  Customer
//
//  Created by webwerks on 11/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class MyReturnListViewModel: NSObject
{
    let APIClient : MyReturnListAPIClient
    var returnItemList : [ReturnItems] = []
    
    init(apiClient: MyReturnListAPIClient = MyReturnListAPIClient()) {
        self.APIClient = apiClient
    }
    
    func myReturnList(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.MyReturnList(for: params) { (response) in
                IProgessHUD.dismiss()
                if let data = response.data, data.count > 0
                {
                    self.returnItemList = data
                    complete()
                }else{
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
            }
        }
    }
}
