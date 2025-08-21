//
//  HelpViewModel.swift
//  Customer
//
//  Created by Priyanka Jagtap on 13/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class HelpViewModel: NSObject {
    
    var helpDetails       : [HelpDetails] = [HelpDetails]()
    
    let APIClient         : HelpRequestAPIClient
    var user_type            : Int = 1
    
    init(apiClient: HelpRequestAPIClient = HelpRequestAPIClient()) {
        self.APIClient = apiClient
    }
    
    //faq
    func getHelpDetails(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.user_type : user_type]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.helpList(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data, data.count > 0
                {
                    self.helpDetails = data
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
