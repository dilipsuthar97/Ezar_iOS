//
//  ProductsViewModel.swift
//  Customer
//
//  Created by webwerks on 6/28/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ProductsViewModel: NSObject {
    
    let APIClient : ProductsAPIClient
   // var product_id              : Int = 0
    var category_id             : Int = 0
    var current_page            : Int = 1
    var tailorProducts          : ReadyMadeProducts?
    var filterArray             : [ProductFilter] = []
    var order_by                : String = ""
    var applyFilterArray        : [NSMutableDictionary] = []
    var product_id              : String = ""
    var vendarID                : String = ""
    var statusCode         : Int = 0
    var type                    : ReviewType = .Product
    var filteredProducts            : ReadyMadeProducts?
    var searchString         : String = ""
    
    init(apiClient: ProductsAPIClient = ProductsAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Home Category
    func getTailoreCategoryProducts(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.category_id :  self.category_id,
                                            API_KEYS.current_page : self.current_page,
                                            API_KEYS.order_by : self.order_by,
                                            API_KEYS.customer_id: Profile.loadProfile()?.id ?? 0,API_KEYS.vendor_id:vendarID]
        //API_KEYS.lang : COMMON_SETTING.lang,
        if applyFilterArray.count > 0
        {
            for dictionary in applyFilterArray
            {
                params.addEntries(from: dictionary as! [AnyHashable : Any])
            }
        }
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.TailoreCategoryProducts(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                self.statusCode = response.code ?? 0
                if let data = response.data
                {
                    if response.data?.filters.count != 0
                    {
                        self.filterArray = (response.data?.filters) ?? []
                    }
//                    self.tailorProducts?.products.removeAll()
//                    self.tailorProducts?.subcategories.removeAll()
                    
                  //  self.filteredProducts = self.current_page == 1 ? data : self.getUpdatedModel(tailorProducts: self.filteredProducts!, data: data)
                    
                    self.tailorProducts = self.current_page == 1 ? data : self.getUpdatedModel(tailorProducts: self.tailorProducts!, data: data)
//                    complete()
                }
                complete()
            })
        }
    }
    
    func getUpdatedModel(tailorProducts : ReadyMadeProducts, data : ReadyMadeProducts) -> ReadyMadeProducts
    {
        var tailorProducts = tailorProducts
        //OLD
//        tailorProducts.category_id = data.category_id
//        tailorProducts.current_page = data.current_page
//        tailorProducts.page_count = data.page_count
//        tailorProducts.products.append(contentsOf: data.products)
        
        if tailorProducts.subcategories.count > 0{
              //      tailorProducts.category_id = data.subcategories[0].category_id
        //            tailorProducts.current_page = data.current_page
                  //  tailorProducts.page_count = data.page_count
            
            let sortedArray =  data.subcategories.sorted(by: {$0.category_position <  $1.category_position})
            
            tailorProducts.subcategories.append(contentsOf: sortedArray)
        }else{
            tailorProducts.category_id = data.category_id
            tailorProducts.current_page = data.current_page
            tailorProducts.page_count = data.page_count
            tailorProducts.products.append(contentsOf: data.products)
        }
                
        
        return tailorProducts
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
                                            API_KEYS.item_id : product_id,
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
}
