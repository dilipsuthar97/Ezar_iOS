//
//  ProductsResponse.swift
//  Customer
//
//  Created by webwerks on 6/28/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductsResponse: BaseResponse
{
    var data : ReadyMadeProducts?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct ReadyMadeProducts: Mappable {
    var category_id         : String = ""
    var products            : [ProductsList] = []
    var subcategories       : [Subcategories] = []
    var seller_detail       : [SellerDetail] = []
    var current_page        : String = ""
    var page_count          : Int = 0
    var filters             : [ProductFilter] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        category_id         <- map["category_id"]
        products            <- map["products"]
        subcategories       <- map["subcategories"]
        current_page        <- map["current_page"]
        page_count          <- map["page_count"]
        filters             <- map["filters"]
        seller_detail       <- map["seller_detail"]
    }
}

struct SellerDetail : Mappable {
    var id : Int = 0
    var vendor_id : String = ""
    var name : String = ""
    var arabic_name : String = ""
    var vendor_email : String = ""
    var total_rating : String = ""
    var logo : String = ""
    var is_favourite : Int = 0

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id               <- map["id"]
        vendor_id        <- map["vendor_id"]
        name             <- map["name"]
        arabic_name      <- map["arabic_name"]
        vendor_email     <- map["vendor_email"]
        total_rating     <- map["total_rating"]
        logo             <- map["logo"]
        is_favourite      <- map["is_favourite"]
    }

}
struct Subcategories : Mappable {
    var category_id : String = ""
    var category_name : String = ""
    var category_name_arabic : String = ""
    var category_description : String = ""
    var category_image : String = ""
    var category_position : String = ""

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        category_id          <- map["category_id"]
        category_name        <- map["category_name"]
        category_name_arabic <- map["category_name_arabic"]
        category_description <- map["category_description"]
        category_image       <- map["category_image"]
        category_position    <- map["category_position"]
    }

}

struct ProductsList: Mappable {
    var id                  : String = ""
    var is_favourite        : Int = -1
    var name                : String = ""
    var sku                 : String = ""
    var is_new              : Int    = -1
    var currency_symbol     : String = ""
    var price               : String = ""
    var per_off             : String = ""
    var special_price       : String = ""
    var image               : String = ""
    var rating_summary      : Int    = 0
    var price_type          : String = ""
    var reward_points       : Int = 0
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        id                  <- map["id"]
        is_favourite        <- map["is_favourite"]
        name                <- map["name"]
        sku                 <- map["sku"]
        is_new              <- map["is_new"]
        currency_symbol     <- map["currency_symbol"]
        price               <- map["price"]
        per_off             <- map["per_off"]
        special_price       <- map["special_price"]
        price_type          <- map["price_type"]
        image               <- map["image"]
        rating_summary      <- map["rating_summary"]
        reward_points       <- map["reward_points"]
    }
}

struct ProductFilter: Mappable {
    var label               : String = ""
    var code                : String = ""
    var type                : String = ""
    var is_applied          : Int = -1
    var options             : [FilterOptions]     = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        label                <- map["label"]
        code                 <- map["code"]
        is_applied           <- map["is_applied"]
        type                 <- map["type"]
        options              <- map["options"]
    }
}


struct FilterOptions: Mappable {
    var display             : String = ""
    var description         : String = ""
    var option_id           : String = ""
    var iOption_id          : Int    = 0
    var count               : Int    = 0
    var color_code          : String = ""
    var image               : String = ""
    var is_applied          : Int = -1
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        display             <- map["display"]
        description         <- map["description"]
        option_id           <- map["option_id"]
        iOption_id          <- map["option_id"]
        count               <- map["count"]
        color_code          <- map["color_code"]
        image               <- map["image"]
        is_applied          <- map["is_applied"]
    }
}
