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

class ShoppingBagViewModel: NSObject {
    
    let APIClient : ShoppingBagRequestAPIClient
    
    var shoppingBagItems                : ShoppingBagItem?
    var customer_id                     : Int = 0
    var itemQuoteId                     : String = ""
    var measurement_id                  : String = ""
    var quoteId                         : String = ""
    var productType                     : String = ""
    var invalidProductList              : [Int] = []
    var selectMeasurementList           : [Int] = []
    var selectFabricList                : [Int] = []
    var product_Id                      : Int = 0
    var fabric_offline                  : Int = -1
    var qty                             : Int = 0
    var delivery_date                   : String = ""
    var category_name                   : String = ""
    var price                           : Double = 0.0
    var special_price                   : String = ""
    var couponCode                      : String = ""
    var is_remove                       : Int = 0
    var type                            : ReviewType = .Product
    
    var isTailorMeasurement = false
    
    init(apiClient: ShoppingBagRequestAPIClient = ShoppingBagRequestAPIClient()) {
        self.APIClient = apiClient
    }
    
    func getShoppingBagDetails(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.product_type : LocalDataManager.getUserSelection(),
                                            API_KEYS.quote_id : self.quoteId]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ShoppingBagDetails(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if response is ShoppingBagResponse
                {
                    
                    let shoppingBagResponse : ShoppingBagResponse = response as! ShoppingBagResponse
                    if let data = shoppingBagResponse.data
                    {
                        self?.shoppingBagItems = data
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
    
    //delete
    func deleteCartItem(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,API_KEYS.item_quote_id : itemQuoteId]
        
        if LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue{
            params.setValue(quoteId, forKeyPath: API_KEYS.quote_id)
            params.setValue(LocalDataManager.getUserSelection(), forKeyPath: API_KEYS.product_type)
        }
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.deleteCartItemAPI(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            })
        }
    }
    
    func applyFabricOffline(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.product_id : self.product_Id,
                                            API_KEYS.quote_id : self.quoteId,
                                            API_KEYS.item_quote_id : self.itemQuoteId,
                                            API_KEYS.customer_id : customer_id,
                                            API_KEYS.product_type : LocalDataManager.getUserSelection(),
                                            API_KEYS.fabric_offline : self.fabric_offline,
                                            API_KEYS.qty : self.qty,
                                            API_KEYS.delivery_date : self.delivery_date]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ApplyFabricOffline(for: params, completionHandler: { [weak self] (response) in
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
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
    
    func removeFromWishList(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.item_id : product_Id,
                                            API_KEYS.type : type.rawValue]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.RemoveFromWishList(for: params) { (response) in
                IProgessHUD.dismiss()
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            }
        }
    }
    
    func applyCouponWS(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.quote_id : self.quoteId,
                                            API_KEYS.coupon_code : couponCode,
                                            API_KEYS.product_type : LocalDataManager.getUserSelection(),
                                            API_KEYS.is_remove : is_remove]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ApplyCouponAPI(for: params) { (response) in
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            }
        }
    }
    
    
    
    func updateMeasurementForCartProduct(complete: @escaping isCompleted){
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.tailor_measurement : isTailorMeasurement,
                                            API_KEYS.item_quote_id: itemQuoteId]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.UpdateMeasurement(for: params, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
}
