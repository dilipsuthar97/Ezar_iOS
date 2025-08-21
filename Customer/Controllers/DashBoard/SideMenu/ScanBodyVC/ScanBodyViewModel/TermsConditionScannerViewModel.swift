//
//  TermsConditionScannerViewModel.swift
//  EZAR
//
//  Created by abc on 16/07/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class TermsConditionScannerViewModel: NSObject {
    
    var termsAndCondition  : [TearmsConditionsScanner] = [TearmsConditionsScanner]()
    
    let APIClient         : TermsConditionScannerApiClient
    var delegate_id            : Int = 0
    
    init(apiClient: TermsConditionScannerApiClient = TermsConditionScannerApiClient()) {
        self.APIClient = apiClient
    }
    
    //Offer
    func getTermsConditionScannerData(complete: @escaping isCompleted) {
        
       let params : NSMutableDictionary = [API_KEYS.identifier : "terms-and-condition-for-body-scanner"]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.termsConditionScanner(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data?.tearmsConditions
                {
                   self.termsAndCondition = data
                    complete()
                }
            })
        }
    }
}
