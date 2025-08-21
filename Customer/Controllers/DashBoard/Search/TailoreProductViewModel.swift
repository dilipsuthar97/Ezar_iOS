//
//  TailoreProductViewModel.swift
//  Customer
//
//  Created by webwerks on 10/8/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class TailoreProductViewModel: NSObject {
    let APIClient               : TailoreProductAPIClient
    var searchProducts          : SearchProducts?
    var filterArray             : [ProductFilter] = []
    var order_by                : String = ""
    var applyFilterArray        : [NSMutableDictionary] = []
    var search_String           : String = ""
    var current_page            : Int = 1
    var page_count              : Int = 0
    
    init(apiClient: TailoreProductAPIClient = TailoreProductAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Home Category
    func getSearch(complete: @escaping isCompleted) {

        let params : NSMutableDictionary = [API_KEYS.search_string : search_String,
                                            API_KEYS.root_category : LocalDataManager.getGenderSelection(),
                                            API_KEYS.current_page : current_page,
                                            API_KEYS.order_by : order_by,
                                            API_KEYS.product_type : LocalDataManager.getUserSelection(),
                                            API_KEYS.page_count : page_count,API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0]
        
        if applyFilterArray.count > 0
        {
            for dictionary in applyFilterArray
            {
                params.addEntries(from: dictionary as! [AnyHashable : Any])
            }
        }
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.SearchProduct(for: params) { (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    if response.data?.filters.count != 0
                    {
                        self.filterArray = (response.data?.filters) ?? []
                    }
                    self.searchProducts = self.current_page == 1 ? data : self.getUpdatedModel(searchProducts: self.searchProducts!, data: data)
                    complete()
                }
            }
        }
    }
    
    func getUpdatedModel(searchProducts : SearchProducts, data : SearchProducts) -> SearchProducts
    {
        var searchProducts = searchProducts
        searchProducts.current_page = data.current_page
        searchProducts.page_count = data.page_count
        searchProducts.products.append(contentsOf: data.products)
        return searchProducts
    }
    
    func addToWishlist(_ params : NSMutableDictionary, complete: @escaping isCompleted)
    {
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.AddToWishlist(for: params) { (response) in
                if let message = response.message{
                    INotifications.show(message: message)
                }
                if let status = response.code, status == 200{
                    complete()
                }
            }
        }
    }
}






