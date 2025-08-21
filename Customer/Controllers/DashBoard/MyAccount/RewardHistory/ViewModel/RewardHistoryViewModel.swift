//
//  RewardHistoryViewModel.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/22/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class RewardHistoryViewModel: NSObject {
    
    var rewardHistoryList   : [RewardHistoryList] = [RewardHistoryList]()
    
    let APIClient         : RewardHistoryApiClient
    var available_balance            : String = ""
    
    init(apiClient: RewardHistoryApiClient = RewardHistoryApiClient()) {
        self.APIClient = apiClient
    }
    
    //RewardHistory
    func getRewardHistory(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.RewardHistory(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let balance = response.data?.available_balance{
                     self.available_balance = balance
                }
              
                if let data = response.data?.list, data.count > 0
                {
                    self.rewardHistoryList = data
                    complete()
                }else{
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
            })
        }
    }
}
