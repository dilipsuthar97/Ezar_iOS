//
//  SubCategoryResponse.swift
//  Customer
//
//  Created by Shrikant Kanakatti on 5/9/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class SubCategoryViewModel: NSObject
{
    let APIClient           : SubCategoryAPIClient
    var subcategoryDetails  : SubCategoryDetails?
//    var subCategories       = [SubCategories]()
//    var products            = [SubProducts]()
    var vendor_id           : Int = 0
    var category_id         : Int = 0
    
    var currentPage         : Int = 1
    var tab_Index           : Int = -1

    
    init(apiClient: SubCategoryAPIClient = SubCategoryAPIClient()) {
        self.APIClient = apiClient
    }
    
    //SubCategories
    func getSubCategoryDetails(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.vendor_id : vendor_id,API_KEYS.category_id : category_id,API_KEYS.delivery_date : COMMON_SETTING.deliveryDate,API_KEYS.lang : COMMON_SETTING.lang]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.SubCategoryDetails(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self.subcategoryDetails = data
                    complete()
                }
            })
        }
    }
    
    
    //SubCategories -- Paging
    func getCategoryProductList(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.vendor_id : vendor_id,API_KEYS.category_id : category_id,API_KEYS.current_page : currentPage,API_KEYS.delivery_date : COMMON_SETTING.deliveryDate,API_KEYS.lang : COMMON_SETTING.lang]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.CategoryProductList(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    if self.tab_Index != -1
                    {
                        self.subcategoryDetails?.childCategories[self.tab_Index].subcategoryProducts.append(contentsOf: data.subproducts)
                    }
                    else
                    {
                        self.subcategoryDetails?.subproducts.append(contentsOf: data.subproducts)
                    }
                    complete()
                }
            })
        }
    }
}

