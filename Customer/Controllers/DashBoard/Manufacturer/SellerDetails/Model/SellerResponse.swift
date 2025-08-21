//
//  SellerResponse.swift
//  Customer
//
//  Created by webwerks on 5/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class SellerResponse: BaseResponse {
    var data : VendorDetail? = nil
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

class SellerAllReviewResponse: BaseResponse {
    var data : Reviews?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data.reviews"]
    }
}

struct VendorDetail: Mappable {
    var id                  : Int    = 0
    var name                : String = ""
    var company             : String = ""
    var street              : String = ""
    var city                : String = ""
    var country_id          : String = ""
    var telephone           : String = ""
    var address             : String = ""
    var entity_id           : String?
    var region              : String = ""
    var vendor_id           : String = ""
    var storeData           : VendorStoreDetail? = nil
    var reviewRatings       : ReviewRating? = nil
    var categories          : String = ""
    var price               : String = ""
    var price_incl_tax      : String = ""
    var per_off             : String = ""
    var price_type          : String = ""
    var model_type          : String = ""
    var special_price       : String = ""
    var url                 : String = ""
    var description         : String?
    var currency_symbol     : String = ""
    var images              : NSArray = NSArray()
    var video               : String = ""
    var info                : String = ""
    var is_style            : Int = -1
    var is_promotion        : Int = 0
    var is_simple           : Int = -1
    var all_options         : [AllOPtions] = []
    var avaliable_options   : [ValueList]  = []
    var sizechart           : String = ""
    var review_type         : String = ""
    var reward_points       : String = ""
    var is_favourite        : Int = 0
    var vendor_name         : String = ""
    var product_pdf         : String = ""
    var qty_promotion       : String = ""
    var delivery_date       : String = ""
    var aprox_delivery      : String = ""
    var delegate_available    : Int  = 1

    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        id                      <- map["id"]
        is_favourite            <- map["is_favourite"]
        name                    <- map["name"]
        company                 <- map["company"]
        street                  <- map["street"]
        city                    <- map["city"]
        country_id              <- map["country_id"]
        telephone               <- map["telephone"]
        address                 <- map["address"]
        entity_id               <- map["entity_id"]
        region                  <- map["region"]
        storeData               <- map["store_data"]
        vendor_id               <- map["vendor_id"]
        reviewRatings           <- map["review_and_ratings"]
        product_pdf             <- map["product_pdf"]
        categories              <- map["categories"]
        price                   <- map["price"]
        price_incl_tax          <- map["price_incl_tax"]
        per_off                 <- map["per_off"]
        price_type              <- map["price_type"]
        special_price           <- map["special_price"]
        url                     <- map["url"]
        model_type              <- map["model_type"]
        description             <- map["description"]
        currency_symbol         <- map["currency_symbol"]
        images                  <- map["images"]
        video                   <- map["video"]
        info                    <- map["info"]
        is_style                <- map["is_style"]
        is_promotion            <- map["is_promotion"]
        is_simple               <- map["is_simple"]
        all_options             <- map["all_options"]
        avaliable_options       <- map["avaliable_options"]
        sizechart               <- map["sizechart"]
        is_favourite            <- map["is_favourite"]
        review_type             <- map["review_type"]
        reward_points           <- map["reward_points"]
        vendor_name             <- map["vendor_name"]
        
        qty_promotion           <- map["qty_promotion"]
        delivery_date           <- map["delivery_date"]
        aprox_delivery          <- map["aprox_delivery"]
        delegate_available          <- map["delegate_available"]

    }
}

struct VendorStoreDetail: Mappable {
    var name                    : String = ""
    var short_description       : String = ""
    var phone                   : String = ""
    var logo                    : String = ""
    var video                   : String = ""
    var banners                 : NSArray = NSArray()
    var description             : String?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        name                <- map["name"]
        short_description   <- map["short_description"]
        phone               <- map["phone"]
        logo                <- map["logo"]
        video               <- map["video"]
        banners             <- map["banners"]
        description         <- map["description"]
    }
}

struct ReviewRating: Mappable {
    var max_rating                    : Int = 0
    var rating                        : String = ""
     // var rating                      : Double    = 0.0
    var reviews                       : Reviews? = nil

    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        max_rating                <- map["max_rating"]
        rating                    <- map["rating"]
        reviews                   <- map["reviews"]
    }
}

struct Reviews: Mappable {
    
    var list                    : [ReviewsList] = []
    var total                   : Int = 0
    var current_page             : Int = 1
    var page_count              : Int = 0

    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        list                <- map["list"]
        total               <- map["total"]
        current_page        <- map["current_page"]
        page_count         <- map["page_count"]

    }
}

struct ReviewsList: Mappable {
    
    var name                   : String = ""
    var certified_buyer        : Bool = false
    var date                   : String = ""
    var dislike                : Int = 0
    var like                   : Int = 0
    var reivew                 : String?
    var review_id              : Any?
    var title                  : String?
    var rating                 : String = ""
    var display_rating         :Int = 0
    var display_review         :Int = 0
    var customer_up_vote       :String = ""

    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        name                <- map["name"]
        certified_buyer     <- map["certified_buyer"]
        date                <- map["date"]
        dislike             <- map["dislike"]
        like                <- map["like"]
        reivew              <- map["reivew"]
        review_id           <- map["review_id"]
        title               <- map["title"]
        rating              <- map["rating"]
        display_rating      <- map["display_rating"]
        display_review      <- map["display_review"]
        customer_up_vote    <- map["customer_up_vote"]

    }
}

struct AllOPtions: Mappable {
    
    var attribute_id        : String = ""
    var option_code         : String = ""
    var option_name         : String = ""
    var options             : [SubOPtions] = []
    
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        attribute_id        <- map["attribute_id"]
        option_code         <- map["option_code"]
        option_name         <- map["option_name"]
        options             <- map["options"]
    }
}

struct SubOPtions: Mappable {
    
    var value           : String = ""
    var label           : String = ""
    var image           : String = ""
    var color           : String = ""
    var isDisable       : Bool   = true
    var isSelected      : Bool   = false
    var isAllDisable     : Bool = true
    var imageUrl        : String = ""
    var avlSet = [Set<String>()]
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        value           <- map["value"]
        label           <- map["label"]
        image           <- map["image"]
        color           <- map["color"]
    }
}

struct ValueList: Mappable {
    
    var valueList           : [AvaliableOptions] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        valueList          <- map["value_list"]
    }
}

struct AvaliableOptions: Mappable {
    
    var label           : String = ""
    var value           : String = ""
    var image           : String = ""

    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        label          <- map["label"]
        value          <- map["value"]
        image          <- map["image"]
    }
}

class ReadymadeAddToCartResponse : BaseResponse {
    var qouteId       : String = ""
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        qouteId <- map ["data.quote_id"]
    }
}

