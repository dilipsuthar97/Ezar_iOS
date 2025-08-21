//
//  LoginViewModel.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class ChooseFabricViewModel: NSObject {
    
    let APIClient : ChooseFabricAPIClient
    
    var chooseFabricProduct             : ChooseFabricProduct?
    var delivery_date                   : String = ""
    var quoteId                         : String = ""
    var itemQuoteId                     : String = ""
    var customer_id                     : Int = Profile.loadProfile()?.id ?? 0
    var productType                     : String = LocalDataManager.getUserSelection()
    var qty                             : Int = 0
    var fabric_offline                  : Int = -1
    var applyFilterArray                : [NSMutableDictionary] = []
    var order_by                        : String = ""
    var product_id                      : String = ""
    var minFabricRequired               : String = ""
    var filteredData                    :[ProductsList] = []
    
    init(apiClient: ChooseFabricAPIClient = ChooseFabricAPIClient()) {
        self.APIClient = apiClient
    }
    
    func getAvailableFabric(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.delivery_date : delivery_date,
                                            API_KEYS.quote_id : quoteId,
                                            API_KEYS.item_quote_id : itemQuoteId,
                                            API_KEYS.customer_id : customer_id,
                                            API_KEYS.product_type : productType,
                                            API_KEYS.order_by : self.order_by]
        
        
        
        if applyFilterArray.count > 0
        {
            for dictionary in applyFilterArray
            {
                params.addEntries(from: dictionary as! [AnyHashable : Any])
            }
        }
        
        
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.AvailableFabric(for: params, completionHandler: { [weak self] (response) in
                if response is ChooseFabricResponse
                {
                    let shoppingBagResponse : ChooseFabricResponse = response as! ChooseFabricResponse
                    if let data = shoppingBagResponse.data
                    {
                        self?.chooseFabricProduct = data
                        self?.filteredData = data.products
                        
                        complete()
                    }
                }
                else
                {
                    complete()
                }
            })
            
        }
    }
    
    func addToWishlist(_ params : NSMutableDictionary, complete: @escaping isCompleted)
    {
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.AddToWishlist(for: params) { (response) in
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            }
        }
    }
}
