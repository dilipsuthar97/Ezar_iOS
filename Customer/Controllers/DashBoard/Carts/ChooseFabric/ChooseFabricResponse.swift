//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class ChooseFabricResponse: BaseResponse {
    
    var data : ChooseFabricProduct?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct ChooseFabricProduct: Mappable {
    var category_id         : Int = 0
    var customer_id         : String = ""
    var quote_id            : String = ""
    var item_quote_id       : String = ""
    var delivery_date       : String = ""
    var products            : [ProductsList] = []
    var current_page        : String = ""
    var page_count          : Int = 0
    var filters             : [ProductFilter] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        category_id         <- map["category_id"]
        customer_id         <- map["customer_id"]
        quote_id            <- map["quote_id"]
        item_quote_id       <- map["item_quote_id"]
        delivery_date       <- map["delivery_date"]
        products            <- map["products"]
        current_page        <- map["current_page"]
        page_count          <- map["page_count"]
        filters             <- map["filters"]
    }
}
