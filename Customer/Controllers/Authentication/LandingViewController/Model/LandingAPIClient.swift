//
//  LandingAPIClient.swift
//  EZAR
//
//  Created by The Appineers on 22/03/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import Foundation
import Alamofire


class LandingAPIClient: NSObject {
    
    func ApplicationConfiguration(completionHandler:
                                  @escaping (LandingResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
    
            let url = URLs.findRepositories(API_URL.configuration)
            IProgessHUD.show()
            
            INetworkManager.performRequest(url: url, method: .get) { (response) in
                if let response = response {
                    if let landingResponse = LandingResponse(JSONString: response){
                        completionHandler(landingResponse)
                    }
                }
            }
        }
    }
}
