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

class FAQsViewModel: NSObject {
    
     var faqDetails           : [FaqDetails] = [FaqDetails]()
 
    let APIClient           : FAQsRequestAPIClient
    var faq_id         : Int = 0
    
    init(apiClient: FAQsRequestAPIClient = FAQsRequestAPIClient()) {
        self.APIClient = apiClient
    }
    
    //SubCategories
    func getFaqDetails(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.faq_id : faq_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.faqList(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
               
                if let data = response.data, data.count > 0
                {
                    self.faqDetails = data
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
