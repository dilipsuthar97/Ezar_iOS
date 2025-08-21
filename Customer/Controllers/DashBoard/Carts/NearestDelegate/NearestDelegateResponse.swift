//
//  NearestDelegateResponse.swift
//  Customer
//
//  Created by webwerks on 7/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class NearestDelegateResponse: BaseResponse
{
    var data : NearestDelegate?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

struct NearestDelegate: Mappable {
    
    var filters             : [ProductFilter] = []
    var nearestDelegateDetail :[NearestDelegateDetail]?
    var page_count : Int = 0
    var current_page : Int = 0
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        filters             <- map["filters"]
        nearestDelegateDetail            <- map["nearest_delegates"]
        page_count   <- map["page_count"]
        current_page   <- map["current_page"]
    }
}


struct NearestDelegateDetail: Mappable {
    
    var name            : String = ""
    var profile_image   : String = ""
    var last_purchase   : String = "NA"
    var rating          : String = ""
    var duration        : String = "NA"
    var seconds         : String = ""
    var delegate_id     : Int = 0
    var is_favourite     : Int = 0
    var commission_charge : String = ""
    var commission_type  : Int = 0
    var currency_symbol : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        name            <- map["name"]
        profile_image   <- map["profile_image"]
        last_purchase   <- map["last_purchase"]
        rating          <- map["rating"]
        duration        <- map["duration"]
        seconds         <- map["seconds"]
        delegate_id     <- map["delegate_id"]
        is_favourite     <- map["is_favourite"]
        commission_charge     <- map["commission_charge"]
        commission_type     <- map["commission_type"]
        currency_symbol <- map["currency_symbol"]
    }
}
