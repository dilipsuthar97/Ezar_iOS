//
//  SearchViewModel.swift
//  Customer
//
//  Created by webwerks on 5/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewModel: NSObject {
    let APIClient : SearchAPIClient
    var searchResult            : SearchData?
    var seller_list             : [SellerList] = []
    var filterArray             : [ProductFilter] = []
    var applyFilterArray        : [NSMutableDictionary] = []
    
    var category_id             : Int = 0
    var delivery_date           : String = ""
    var longitude               : Double = 0.00 //24.760548328565893 //Testing
    var latitude                : Double = 0.00 //46.65618853906244  //Testing
    var qty                     : Int = 0
    var current_page            : Int = 1
    var order_by                : String = ""
    var categoryName            : String = ""
    var max_capacity            : String = "0"
    var is_promotion            : Int = 0
    var search_String           : String = ""
    var isFrommanufactureserach  = false
    var is_delegate_available            : Int = 1

    
    init(apiClient: SearchAPIClient = SearchAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Home Category
    func getSearchData(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.category_id : category_id,
                                            API_KEYS.delivery_date : delivery_date,
                                            API_KEYS.longitude: longitude,
                                            API_KEYS.latitude: latitude,
                                            API_KEYS.qty: qty,
                                            API_KEYS.current_page : current_page,
                                            API_KEYS.order_by : order_by ,
                                            API_KEYS.lang : COMMON_SETTING.lang,
                                            API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            "is_delegate_available" : is_delegate_available,
                                            
        ]
        
        if !(search_String.isEmpty)
        {
            params.addEntries(from: [API_KEYS.search_string : search_String])
        }
        
        if applyFilterArray.count > 0
        {
            for dictionary in applyFilterArray
            {
                params.addEntries(from: dictionary as! [AnyHashable : Any])
            }
        }

        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.Search(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    COMMON_SETTING.deliveryDate = (self?.delivery_date) ?? ""
                    COMMON_SETTING.quantity = (self?.qty) ?? 0
                    if response.data?.filters.count != 0
                    {
                        self?.filterArray = (response.data?.filters) ?? []
                    }
                    self?.searchResult = data
                    
                    if self?.current_page == 1
                    {
                        self?.seller_list = []
                    }
//                    if self?.search_String == ""{
//                        if self?.seller_list.count ?? 0 > 0{
//                            self?.seller_list.removeAll()
//                        }
//                    }
                    self?.seller_list.append(contentsOf: data.sellers_list)
                   // INotifications.show(message: response.message ?? "")
                    complete()
                }
            })
        }
    }
}
