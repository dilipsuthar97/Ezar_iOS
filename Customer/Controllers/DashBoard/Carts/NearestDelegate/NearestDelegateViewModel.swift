//
//  NearestDelegateViewModel.swift
//  Customer
//
//  Created by webwerks on 7/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class NearestDelegateViewModel: NSObject {

    let APIClient : NearestDelegateAPIClient!
    var delegateList : [NearestDelegateDetail] = [NearestDelegateDetail]()
    var requestDelegateModel : RequestDelegateModel = RequestDelegateModel()
    var filters : [ProductFilter] = []
    var pageCount : Int = 0
    var current_page : Int = 1
    var isSeller : Int =  0
    var vendorId : Int =  0
    var customer_id : Int = Profile.loadProfile()?.id ?? 0
    var delegateId : Int =  0
    var is_favourite : Int =  0
    var is_promotion : Int = 0
    var category_id : Int = 0
    var order_by: String = ""
    var applyFilterArray        : [NSMutableDictionary] = []

    init(apiClient: NearestDelegateAPIClient = NearestDelegateAPIClient()) {
        self.APIClient = apiClient
    }
    
    //NearestDelegateList Options
    func getNearestDelegateList(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.latitude : requestDelegateModel.latitude,
                                            API_KEYS.longitude : requestDelegateModel.longitude,
                                            API_KEYS.current_page : self.current_page,
                                            API_KEYS.product_type : LocalDataManager.getUserSelection(),
                                            API_KEYS.quote_id : requestDelegateModel.quote_id,
                                            API_KEYS.product_id : requestDelegateModel.productId,
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
            
            APIClient.NearestDelegateList(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data,data.nearestDelegateDetail?.count != 0
                {
                    if self?.delegateList.count ?? 0 > 0
                    {
                        self?.delegateList.removeAll()
                    }
                    if data.nearestDelegateDetail != nil
                    {
                        self?.delegateList.append(contentsOf: data.nearestDelegateDetail!)
                    }
                    self?.filters = data.filters
                    self?.pageCount = data.page_count
                    self?.current_page = data.current_page
                    complete()
                }else{
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
            })
        }
    }
    
    //Submit favourite
    func addToFavourite(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.delegate_id : delegateId,
                                            API_KEYS.vendor_id : vendorId,
                                            API_KEYS.is_seller : isSeller,
                                            API_KEYS.is_favourite : is_favourite,
                                            API_KEYS.category_id : category_id,
                                            API_KEYS.is_promotion : is_promotion]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()

            APIClient.AddToFavouriteAPI(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
             
                if let message = response.message{
                    INotifications.show(message: message)
                }
                if let status = response.code, status == 200{
                complete()
                }
            })
        }
    }
}



    
    
    
    

