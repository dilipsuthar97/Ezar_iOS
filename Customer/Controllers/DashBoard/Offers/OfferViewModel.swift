//
//  OfferViewModel.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/22/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class OfferViewModel: NSObject {
    
    var offer  : [Offer] = [Offer]()
    
    let APIClient         : OfferApiClient
    var delegate_id            : Int = 0
    
    init(apiClient: OfferApiClient = OfferApiClient()) {
        self.APIClient = apiClient
    }
    
    //Offer
    func getOffer(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.identifier : "offer"]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.Offer(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data?.offer, data.count > 0
                {
                    self.offer = data
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
