//
//  OrderViewModel.swift
//  Customer
//
//  Created by webwerks on 9/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class OrderDetailViewModel: NSObject
{
    let APIClient : OrderDetailAPIClient
    var orders : orderDetails?
    var orderId : Int = 1
    var reOrderItem : ItemList?
    var responseCode : Int = 0
    var reOrderSuccessArray : [Int] = []
    var status : String = ""
    
    init(apiClient: OrderDetailAPIClient = OrderDetailAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Sorted orders
    func GetOrderDetailsAPI(complete: @escaping isCompleted)
    {
        let customer_id = Profile.loadProfile()?.id ?? 0
        
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id, API_KEYS.order_id : orderId]
        
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.GetOrderDetails(for: params) { [weak self] (response) in
                IProgessHUD.dismiss()
                if response.code == 200, let data = response.data
                {
                    self?.orders = data
                }
                else
                {
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
                complete()
            }
        }
    }
    
    func addToCartReadyMadeProduct(complete: @escaping isCompleted)
    {
        let profile = Profile.loadProfile()
        let custmerID = profile?.id ?? 0
        let params : NSMutableDictionary = [API_KEYS.product_id:reOrderItem?.product_id ?? 0,
                                            API_KEYS.product_type:"R",
                                            API_KEYS.qty:reOrderItem?.qty_ordered ?? 1,
                                            API_KEYS.customer_id:custmerID,
                                            API_KEYS.category_name:"",
                                            API_KEYS.quote_id:0,
                                            API_KEYS.reward_points: self.orders?.reward_credited ?? 0,
                                            API_KEYS.category_id: 0]
        
        
        
        if reOrderItem?.extra_info?.attributes_info.count ?? 0 > 0
        {
            for attributes_info in reOrderItem?.extra_info?.attributes_info ?? []
            {
                let key : String = String(format: "%d", attributes_info.option_id)
                var value : String = String(format: "%d", attributes_info.option_value)
                if value == "0" || value.isEmpty
                {
                    value = attributes_info.sOption_value
                }
                let formatedKey : String = "super_attribute[\(key)]"
                let dictionary : [String : String] = [formatedKey:value]
                params.addEntries(from: dictionary)
            }
        }
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.AddToCart(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let message = response.message{
                    INotifications.show(message: message)
                }
                self.responseCode = response.code ?? 0
                if self.responseCode == 200
                {
                    self.reOrderSuccessArray.append(self.responseCode)
                }
                complete()
            })
        }
    }

    func cancelOrder(complete: @escaping isCompleted) {
        
        //https://ezarksa.com/customapi/customer/OrderCancel?customer_id=10858&order_id=896
        
        //https://ezarksa.com/customapi/order/OrderCancel?customer_id=10858&order_id=893
        let customer_id = Profile.loadProfile()?.id ?? 0
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id, API_KEYS.order_id : orderId]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.cancelOrder(for: params, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    
    func updateMeasurement(complete: @escaping isCompleted) {
        
        //https://ezarksa.com/customapi/customer/OrderCancel?customer_id=10858&order_id=896
        //https://ezarksa.com/customapi/order/OrderCancel?customer_id=10858&order_id=893
        
        let customer_id = Profile.loadProfile()?.id ?? 0
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id, API_KEYS.order_id : orderId, API_KEYS.status : status]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.updateMeasurement(for: params, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    
}
