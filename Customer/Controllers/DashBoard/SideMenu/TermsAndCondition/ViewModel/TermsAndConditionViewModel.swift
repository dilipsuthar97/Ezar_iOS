//
//  TermsAndConditionViewModel.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/3/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class TermsAndConditionViewModel: NSObject {
    
    var termsAndCondition   : [TearmsConditions] = [TearmsConditions]()
    
    let APIClient         : TermsAndConditionApiClient
    var delegate_id            : Int = 0
    
    init(apiClient: TermsAndConditionApiClient = TermsAndConditionApiClient()) {
        self.APIClient = apiClient
    }
    
    //TermsAndCondition
    func getTermsAndCondition(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.identifier : "tearms-conditions"]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.TermsAndCondition(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data?.tearmsConditions, data.count > 0
                {
                    self.termsAndCondition = data
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
