//
//  InviteFriends+Service.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Alamofire
import Foundation

class InviteFriendService: NSObject {
    
    // profile/details
    func getReferralCodeWS(for params: anyDict,
                       completionHandler: @escaping isCompleted) {
        
        if IConnectivityService.isConnectedToInternet() {
            let url = URLs.findRepositories("customapi/customer/invitefriends")
            INetworkManager.performRequest(url: url, param: params) { (response) in
                if let response = response {
                    if let offerResponse = InviteFriendRespose(JSONString: response){
                        if let referral_code = offerResponse.data?.referral_code {
                            LocalDataManager.saveReferralCode(referral_code)
                            
                            // Save url if already added
                            if let url = offerResponse.data?.url {
                                LocalDataManager.saveShareLink(url)
                            }
                            completionHandler()
                        }
                    }
                }
            }
        }
    }
}
