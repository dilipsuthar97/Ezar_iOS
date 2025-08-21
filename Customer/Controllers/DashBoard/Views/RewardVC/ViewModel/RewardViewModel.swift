//
//  RewardViewModel.swift
//  Customer
//
//  Created by webwerks on 9/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class RewardViewModel: NSObject
{
    let APIClient : RewardAPIClient
    var rewards : Rewards?
    
    init(apiClient: RewardAPIClient = RewardAPIClient()) {
        self.APIClient = apiClient
    }
    
    func getRewardPoints(complete: @escaping isCompleted)
    {
        let customer_id = Profile.loadProfile()?.id ?? 0
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.RewardPoints(for: params) { [weak self] (response) in
                IProgessHUD.dismiss()
                if response.code == 200, let data = response.data
                {
                    self?.rewards = data
                }
                else
                {
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
                complete()
            }
        }
    }
}
