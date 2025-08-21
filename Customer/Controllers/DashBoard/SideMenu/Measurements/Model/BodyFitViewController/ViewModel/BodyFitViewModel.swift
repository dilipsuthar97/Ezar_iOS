//
//  BodyFitViewModel.swift
//  EZAR
//
//  Created by abc on 31/08/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class BodyFitViewModel: NSObject {
    
    var fit_options_array : [Fit_options_data]?
    
    let APIClient         : BodyFitApiClient
    var responseCode = 0
    var selected_type = ""
    var fit_type            : Int = 0
    
    init(apiClient: BodyFitApiClient = BodyFitApiClient()) {
        self.APIClient = apiClient
    }
    
    //Offer
    func getBodyFit(complete: @escaping isCompleted) {        
        let params : NSMutableDictionary = ["" : ""]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.bodyFit(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                self.responseCode = response.code ?? 0
                if let data = response.data?.fit_options , data.count > 0 {
                    self.fit_options_array = data
                    complete()
                }else {
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
            })
        }
    }
}
