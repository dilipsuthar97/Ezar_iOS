//
//  SaveAddressViewModel.swift
//  Customer
//
//  Created by webwerks on 9/26/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class SaveAddressViewModel: NSObject
{
    let APIClient       : SaveAddressAPIClient
    var addressList     : [AddressList] = []
    var address_id      : Int = 0

    init(apiClient: SaveAddressAPIClient) {
        self.APIClient = apiClient
    }
    
    func getAddress(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.GetAddress(for: params) { (response) in
                IProgessHUD.dismiss()
                if let data = response.data, data.count > 0
                {
                    if self.addressList.count > 0
                    {
                        self.addressList.removeAll()
                    }
                    self.addressList = data
                }
                else
                {
                    INotifications.show(message: response.message ?? "No data found")
                }
                complete()
            }
        }
    }
    
    func removeAddress(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.address_id : address_id]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.RemoveAddress(for: params) { (response) in
                IProgessHUD.dismiss()
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            }
        }
    }
    
}
