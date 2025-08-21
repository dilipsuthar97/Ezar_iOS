//
//  FavoriteResponse.swift
//  Customer
//
//  Created by webwerks on 10/4/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class FavoriteResponse: BaseResponse
{
    var data : FavoriteObject?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct FavoriteObject: Mappable {
    
    var delegates : FavoriteModel?
    var products : FavoriteModel?
    var sellers : FavoriteModel?
    
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        delegates       <- map["delegates"]
        products        <- map["products"]
        sellers         <- map["sellers"]
    }
}

struct FavoriteModel: Mappable {
    var current_page    : Int = 0
    var page_count      : Int = 0
    var items           : [Items] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        current_page   <- map["current_page"]
        page_count     <- map["page_count"]
        items          <- map["items"]
    }
}

struct Items: Mappable {
    var address         : String = ""
    var delegate_id     : Int = 0
    var id              : Int = 0
    var is_available    : Int = 0
    var is_favourite    : Int = 0
    var name            : String = ""
    var name_arabic     : String = ""
    var profile_image   : String = ""
    var category_name   : String = ""
    var customer_id     : String = ""
    var image           : String = ""
    var item_id         : Int = 0
    var original_qty    : Int = 0
    var product_id      : Int = 0
    var product_type    : String = ""
    var qty             : Int = 0
    var quote_id        : Int = 0
    var rating          : String = ""
    var valid           : Int = 0
    var delivery_date   : String = ""
    var isBrake         : Int = 0
    var isDiff          : Int = 0
    var isExist         : Int = 0
    var itemId          : Int = 0
    var item_quote_id   : String = ""
    var move_cart       : Int = 0
    var price           : String = ""
    var special_price   : String = ""
    var style           : String = ""
    var distance        : String = ""
    var store_name      : String = ""
    var vendor_id       : Int = 0
    var country_code    : String = ""
    var mobile_number   : String = ""
    var attributes_info : [AttributesInfo]        = []
    var category_id     : String = ""
    var is_promotion    : String = ""
    var start_from    : String = ""

    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        address         <- map["address"]
        delegate_id     <- map["delegate_id"]
        id              <- map["id"]
        is_available    <- map["is_available"]
        is_favourite    <- map["is_favourite"]
        name            <- map["name"]
        name_arabic     <- map["name_arabic"]
        profile_image   <- map["profile_image"]
        category_name   <- map["category_name"]
        customer_id     <- map["customer_id"]
        image           <- map["image"]
        item_id         <- map["item_id"]
        original_qty    <- map["original_qty"]
        product_id      <- map["product_id"]
        product_type    <- map["product_type"]
        qty             <- map["qty"]
        quote_id        <- map["quote_id"]
        rating          <- map["rating"]
        valid           <- map["valid"]
        delivery_date   <- map["delivery_date"]
        isBrake         <- map["isBrake"]
        isDiff          <- map["isDiff"]
        isExist         <- map["isExist"]
        itemId          <- map["itemId"]
        item_quote_id   <- map["item_quote_id"]
        move_cart       <- map["move_cart"]
        price           <- map["price"]
        special_price   <- map["special_price"]
        style           <- map["style"]
        distance        <- map["distance"]
        store_name      <- map["store_name"]
        vendor_id       <- map["vendor_id"]
        country_code    <- map["country_code"]
        mobile_number   <- map["mobile_number"]
        attributes_info <- map["attributes_info"]
        category_id     <- map["category_id"]
        is_promotion    <- map["is_promotion"]
        start_from    <- map["start_from"]
    }
}


