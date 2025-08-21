//
//  EditProfileAPIClient.swift
//  Customer
//
//  Created by Priyanka Jagtap on 18/05/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class EditProfileAPIClient: NSObject {
   
    func editProfile(for params: NSMutableDictionary,
                     images : [MultipartFile]?,
                     completionHandler: @escaping (EditProfileRespose) -> Void) {

        if IConnectivityService.isConnectedToInternet() {
            IProgessHUD.show()
            let url = URLs.findRepositories(API_URL.editprofile)
            let params : Parameters = params as! Parameters

            INetworkManager.multipartRequest(param: params,
                                             data: images,
                                             endPointUrl: url) { (response) in
                if let response = response {
                    if let editProfileRespose = EditProfileRespose(JSONString : response){
                        completionHandler(editProfileRespose)
                    }
                }
            }
        }
    }
}
