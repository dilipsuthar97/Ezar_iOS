//
//  SubCategoryResponse.swift
//  Customer
//
//  Created by Shrikant Kanakatti on 5/9/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class SubCategoryResponse: BaseResponse {
    
    var data : SubCategoryDetails?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct SubCategoryDetails: Mappable {
    
    var category_name   : String = ""
    var category_id     : Int = 0
    var vendor_id       : Int = 0
    var current_page    : Int = 0
    var page_count      : Int = 0
    var childCategories : [SubCategories] = [] //Consider it - If Tab values are Present
    var subproducts     : [SubProducts] = [] //Consider it - If Tab values are NOT Present
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
    
        category_name       <- map["cat_name"]
        category_id         <- map["category_id"]
        current_page        <- map["current_page"]
        page_count          <- map["page_count"]
        vendor_id           <- map["vendor_id"]
        childCategories     <- map["child_categories"]
        subproducts         <- map["products"]
    }
}

struct SubCategories: Mappable {
    
    var subcategory_id          : String = ""
    var subcategory_name        : String = ""
    var page_count              : Int = 0
    var subcategoryProducts     : [SubProducts] = []
 
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        subcategory_id                  <- map["id"]
        subcategory_name                <- map["name"]
        page_count                      <- map["page_count"]
        subcategoryProducts             <- map["products"]
    }
}

class SubProducts : Mappable {
    
    var product_id                : String = ""
    var product_name              : String?
    var product_sku               : String?
    var isNewProduct              : Bool = false
    var product_price             : String = ""
    var product_image             : String?
    var product_rating            : String = ""
    var special_price             : String?
    var per_off                   : String?
    var currency_symbol           : String = ""
    var reward_points             : Int = 0
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
     func mapping(map: Map) {
        product_id                <- map["id"]
        product_name              <- map["name"]
        product_sku               <- map["sku"]
        isNewProduct              <- map["is_new"]
        product_price             <- map["price"]
        product_image             <- map["image"]
        product_rating            <- map["rating_summary"]
        special_price             <- map["special_price"]
        per_off                   <- map["per_off"]
        currency_symbol           <- map["currency_symbol"]
        reward_points             <- map ["reward_points"]
    }
}

