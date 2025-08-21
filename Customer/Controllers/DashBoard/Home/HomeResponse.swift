//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeResponse: BaseResponse {
    
    var data : HomeCategory?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
         super.mapping(map: map)
        data <- map ["data"]
    }
}

struct HomeCategory: Mappable {
    
    var categories : [Category] = []
    var product_type : String = ""
    var cart_count : Int = 0
    var root_category : Int = 0
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        categories        <- map["categories"]
        product_type      <- map["product_type"]
        cart_count        <- map["cart_count"]
        root_category     <- map["root_category"]
    }
}

struct Category: Mappable {
    var id              : Int?
    var name            : String = ""
    var imageUrl        : String?
    var max_capacity    : String = ""
    var imax_capacity   : Int = 0
    var advertisement   : [HomePromotion] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        imageUrl        <- map["image_url"]
        max_capacity    <- map["max_capacity"]
        imax_capacity   <- map["max_capacity"]
        advertisement   <- map["advertisement"]
    }
}

//struct HomeCategoryAdvertisement: Mappable {
//    var title1              : String = ""
//    var title2              : String = ""
//    var image_url           : String = ""
//
//    init?(map: Map) {
//
//    }
//
//    // Mappable
//    mutating func mapping(map: Map) {
//        title1              <- map["title1"]
//        title2              <- map["title2"]
//        image_url           <- map["image_url"]
//    }
//}


// Promotions

class HomePromotionResponse : BaseResponse {
    
    var data : [HomePromotion]?
    var bottomData : [HomePromotion]?

    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        super.mapping(map: map)
        data         <- map ["data.top"]
        bottomData   <- map ["data.bottom"]
    }
}

struct HomePromotion : Mappable {
    
    var promotionId             : Int    = 0
    var promotionRootId         : Int    = 0
    var promotionTitle          : String = ""
    var promotionImageUrl       : String = ""
    var promotionProductType    : String = ""
    var promotionType           : String = ""
    var subTitle                : String = ""
    var category_name           : String = ""
    var max_capacity            : Int    = 0
    var parent_category_id      : Int    = 0

    init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    // Mappable
    
    mutating func mapping(map: Map) {
        promotionId             <- map["promo_type_id"]
        promotionRootId         <- map["root_category"]
        promotionTitle          <- map["title1"]
        promotionImageUrl       <- map["image"]
        promotionProductType    <- map["product_type"]
        promotionType           <- map["promo_type"]
        subTitle                 <- map["title2"]
        max_capacity            <- map["max_capacity"]
        category_name           <- map["category_name"]
        parent_category_id      <- map["parent_category_id"]
    }
}

