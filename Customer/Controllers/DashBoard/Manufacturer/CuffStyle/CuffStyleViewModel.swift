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

class CuffStyleViewModel: NSObject {
    
    let APIClient : CuffStyleAPIClient
    var model_type              : Int = 0
    var product_id              : Int = 0
    var productOption           : [ProductOption] = [ProductOption]()
    
    var customer_id             : Int = 0
    var styleDic                : [NSMutableDictionary] = [NSMutableDictionary]()
    var quantity                : String = ""
    var delivery_date           : String = ""
    var item_quote_id           : String = ""
    var category_Name           : String = ""
    var price                   : String = ""
    var specialPrice            : String = ""
    var is_promotion            : Int = 0
    var reward_points           : String = ""
    var responseCode            : Int = 0
    
    var styles                  : [ShoppingBagItemStyle]        = []
    var dependancyArray = [String : [ProductOptionValues]]()

    init(apiClient: CuffStyleAPIClient = CuffStyleAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Product Options
    func getProductOptions(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.model_type : model_type,
                                            API_KEYS.product_id : product_id,
                                            API_KEYS.is_promotion : is_promotion,
                                            API_KEYS.delivery_date : COMMON_SETTING.deliveryDate,
                                            API_KEYS.qty : COMMON_SETTING.quantity,
                                            API_KEYS.lang : COMMON_SETTING.lang]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ProductOptions(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self?.productOption = data
                    complete()
                }
            })
        }
    }
    
    //Product Details with Style - add to cart
    func setProductDetails(complete: @escaping isCompleted)
    {
       
        let jsonString : String = COMMON_SETTING.json(from: styleDic) ?? ""
        let params : NSMutableDictionary = [API_KEYS.customer_id: customer_id,
                                            API_KEYS.product_id: product_id,
                                            API_KEYS.category_name: category_Name,
                                            API_KEYS.style: jsonString,
                                            API_KEYS.qty: quantity,
                                            API_KEYS.price: price,
                                            API_KEYS.special_price: specialPrice,
                                            API_KEYS.delivery_date: delivery_date,
                                            API_KEYS.item_quote_id: item_quote_id,
                                            API_KEYS.reward_points: reward_points]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ProductDetails(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                self.responseCode = response.code ?? 0
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            })
        }
    }
}
