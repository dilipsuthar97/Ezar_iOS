//
//  ImageIntroAPIClient.swift
//  EZAR
//
//  Created by Shruti Gupta on 2/14/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

class ImageIntroAPIClient: NSObject {
    
    func ImageIntroAPI(for params: NSMutableDictionary, completionHandler: @escaping (ImageIntroResponse) -> Void) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories(API_URL.getimages)
            let params : Parameters = params as! Parameters

            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
               if let baseResponse = ImageIntroResponse(JSONString : response){
                    completionHandler(baseResponse)
                   }
                }
            }
        }
    }
}
