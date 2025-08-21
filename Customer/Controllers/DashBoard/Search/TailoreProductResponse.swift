//
//  TailoreProductResponse.swift
//  Customer
//
//  Created by webwerks on 10/8/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class TailoreProductResponse: BaseResponse
{
    var data : SearchProducts?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct SearchProducts: Mappable {
    var products            : [ProductsList] = []
    var per_page            : String = ""
    var page_count          : Int = 0
    var current_page        : String = ""
    var filters             : [ProductFilter] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        per_page            <- map["per_page"]
        products            <- map["products"]
        current_page        <- map["current_page"]
        page_count          <- map["page_count"]
        filters             <- map["filters"]
    }
}
