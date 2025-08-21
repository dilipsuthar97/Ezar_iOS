//
//  FavoriteViewModel.swift
//  Customer
//
//  Created by webwerks on 10/4/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class FavoriteViewModel: NSObject
{
    let APIClient : FavoriteAPIClient?
    var favoriteObject : FavoriteObject?
    var type : String = ""
    var current_page : Int = 1
    var item_id : Int = 0
    var errorCode : Int = 0
    
    init(apiClient: FavoriteAPIClient = FavoriteAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Get Wish List
    func getWishList(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.current_page : current_page,
                                            API_KEYS.type : type]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient?.GetWishList(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self?.favoriteObject = data
                    complete()
                }
            })
        }
    }
    
    func removeFromWishList(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.item_id : item_id,
                                            API_KEYS.type : type]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient?.RemoveFromWishList(for: params) { (response) in
                IProgessHUD.dismiss()
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            }
        }
    }
    
    //add to cart
    func addToCart(_ params : NSMutableDictionary, complete: @escaping isCompleted)
    {
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient?.ProductDetails(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let message = response.message{
                    self.errorCode = response.code ?? 0
                    INotifications.show(message: message)
                }
                complete()
            })
        }
    }
}
