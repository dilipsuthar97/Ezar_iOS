//
//  ScanBodyViewModel.swift
//  EZAR
//
//  Created by abc on 15/07/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class ScanBodyViewModel: NSObject {
    
    fileprivate static let userDefaultsObj = UserDefaults.standard
    fileprivate static let isUserCanSkipTermsConditions = "isUserCanSkipTermsConditions"
    
    var data  : ScanData?
    
    let APIClient         : ScanBodyApiClient
    var delegate_id            : Int = 0
    
    init(apiClient: ScanBodyApiClient = ScanBodyApiClient()) {
        self.APIClient = apiClient
    }
    
    //Offer
    func getScanData(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = ["" : ""]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.scanBody(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data
                {
                    self.data = data
                    complete()
                }
            })
        }
    }
    
    //MARK:- TermsAndConditions skip option
    static func setTermsConditionsSkipOption(_ selection : Bool){
        userDefaultsObj.set(selection, forKey: isUserCanSkipTermsConditions)
        userDefaultsObj.synchronize()
    }
    
    static func getTermsConditionsSkipOption()-> Bool {
        if let selection = userDefaultsObj.object(forKey: isUserCanSkipTermsConditions) as? Bool {
            return selection
        } else {
            return false
        }
    }
    
    
}
