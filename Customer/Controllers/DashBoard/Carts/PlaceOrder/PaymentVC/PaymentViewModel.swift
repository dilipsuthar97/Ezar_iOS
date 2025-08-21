//
//  PaymentViewModel.swift
//  Customer
//
//  Created by webwerks on 6/5/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class PaymentViewModel: NSObject {
    
    let APIClient           : PaymentAPIClient
    var placeOrderModel     : PlaceOrderModel?
    var paymentMethods      : PaymentMethod?
    
    var detailModel : AddressViewModel?
    var customer_id : Int = Profile.loadProfile()?.id ?? 0
    var payment : NSMutableDictionary = NSMutableDictionary()
    var discount : NSMutableDictionary = NSMutableDictionary()
    var tax : NSMutableDictionary = NSMutableDictionary()
    var shipping : NSMutableDictionary = NSMutableDictionary()
    var request_id : Int = 0
    var giftWrap : Int = 0
    var applied_reward_points : Double = 0.0
    var current_conversion_rate : Double = 0.0
    var rewards_converted_to_currency : Double = 0.0
    var totalPayable : Double = -1.0
    var commissionNormal : Int = 0
    var useRewardPointsText : Double = 0.0
    var responseCode : Int = 0
    init(apiClient: PaymentAPIClient = PaymentAPIClient()) {
        self.APIClient = apiClient
    }
    
    //PlaceOrder
    func placeOrder(complete: @escaping isCompleted)
    {
        let shippingJson = COMMON_SETTING.json(from: shipping) ?? ""
        let paymentJson = COMMON_SETTING.json(from: payment) ?? ""
        let discountJson = COMMON_SETTING.json(from: discount) ?? ""
        let taxJson = COMMON_SETTING.json(from: tax) ?? ""
        
        
        let params : NSMutableDictionary = [API_KEYS.customer_id: customer_id,
                                            API_KEYS.shipping: shippingJson,
                                            API_KEYS.payment: paymentJson,
                                            API_KEYS.discount: discountJson,
                                            API_KEYS.tax: taxJson,
                                            API_KEYS.gift_wrap : giftWrap,
                                            API_KEYS.applied_reward_points : applied_reward_points,
                                            API_KEYS.current_conversion_rate : current_conversion_rate,
                                            API_KEYS.rewards_converted_to_currency : rewards_converted_to_currency,
                                            API_KEYS.product_type: LocalDataManager.getUserSelection(),
                                            API_KEYS.request_id: request_id,
        API_KEYS.commission: commissionNormal]
        
        if LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue
        {
            params.addEntries(from: [API_KEYS.quote_id : detailModel?.shoppingBagItems?.quote_id ?? "",])
        }
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.Payment(for: params, completionHandler: { [weak self] (response) in
                self?.responseCode = response.code ?? 0
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self?.placeOrderModel = data
                    complete()
                }
            })
        }
    }
    
    //Get Payment Method Listing
    func getPaymentMethods(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.PaymentMethodList(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self?.paymentMethods = data
                    complete()
                }
            })
        }
    }
}

    

