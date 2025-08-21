//
//  ConnectivityService.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Alamofire
import Foundation

class IConnectivityService {
    static func isConnectedToInternet() -> Bool {
        if NetworkReachabilityManager()!.isReachable {
            return true
        } else {
            INotifications.show(message: MESSAGE.noInternet.localized,
                                type: .error)
            //IProgessHUD.dismiss()
            return false
        }
    }
}
