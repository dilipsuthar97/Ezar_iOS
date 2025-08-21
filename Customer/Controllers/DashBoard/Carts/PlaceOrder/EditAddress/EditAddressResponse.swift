//
//  EditAddressResponse.swift
//  Customer
//
//  Created by webwerks on 5/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class EditAddressResponse: BaseResponse {
    var data : [ShippingMethods]?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data.methods"]
    }
}

struct ShippingMethods: Mappable {
   
    var title               : String                    = ""
    var title_arabic        : String                    = ""
    var price               : Int                       = 0
    var shoppingDetails     : [ShippingDetails]         = []
    var currency_symbol     : String                    = ""

    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        title                <- map["title"]
        title_arabic         <- map["title_arabic"]
        price                <- map["price"]
        shoppingDetails      <- map["details"]
        currency_symbol      <- map["currency_symbol"]

    }
}
struct ShippingDetails: Mappable {
    var item_quote_id           : String                = ""
    var product_id              : String                = ""
    var price                   : Int                   = 0
    var shipping_code           : String                = ""
    var qty                     : String                = ""
    var reward_points           : Int                   = 0
    var total_reward_points     : Int                   = 0
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        item_quote_id           <- map["item_quote_id"]
        product_id              <- map["product_id"]
        price                   <- map["price"]
        shipping_code           <- map["shipping_code"]
        qty                     <- map["qty"]
        reward_points           <- map["reward_points"]
        total_reward_points     <- map["total_reward_points"]
    }
}

