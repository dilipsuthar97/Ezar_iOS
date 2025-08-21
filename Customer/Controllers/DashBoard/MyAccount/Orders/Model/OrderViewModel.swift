//
//  OrderViewModel.swift
//  Customer
//
//  Created by webwerks on 9/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class OrderViewModel: NSObject {
    let APIClient: OrderAPIClient
    var orders: GetOrders?
    
    var productType: String = ""
    var currentPage: Int = 1
    var allOrders : OrdersData?

    init(apiClient: OrderAPIClient = OrderAPIClient()) {
        self.APIClient = apiClient
    }
    
    func getAllOrders(complete: @escaping isCompleted) {
        let customer_id = Profile.loadProfile()?.id ?? 0
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.current_page : currentPage]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.GetAllOrdersAPI(for: params) { [weak self] (response) in
                IProgessHUD.dismiss()
                if response.code == 200, let data = response.allOrdersdata {
                    self?.allOrders = data
                    complete()
                } else {
                    INotifications.show(message: TITLE.customer_no_allorders.localized)
                }
            }
        }
    }
    
    //Sorted orders
    func getOrders(complete: @escaping isCompleted) {
        let customer_id = Profile.loadProfile()?.id ?? 0
        let params: NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                           API_KEYS.product_type : productType,
                                           API_KEYS.current_page : currentPage]
        
        if COMMON_SETTING.isConnectedToInternet() {
            APIClient.GetOrders(for: params) { [weak self] (response) in
                if response.code == 200, let data = response.data {
                    self?.orders = data
                } else {
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
                complete()
            }
        }
    }
}
