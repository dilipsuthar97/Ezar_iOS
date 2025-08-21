//
//  SearchResponse.swift
//  Customer
//
//  Created by webwerks on 5/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchResponse: BaseResponse
{
     var data : SearchData?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct SearchData: Mappable
{
    var sellers_list            : [SellerList]      = []
    var total_sellers           : Int               = 0
    var per_page                : String            = ""
    var current_page            : String            = ""
    var page_count              : Int               = 0
    var filters                 : [ProductFilter] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        sellers_list            <- map["sellers_list"]
        total_sellers           <- map["total_sellers"]
        per_page                <- map["per_page"]
        current_page            <- map["current_page"]
        page_count              <- map["page_count"]
        filters                 <- map["filters"]
    }
}

struct SellerList: Mappable {
    var vendorId        : Int?
    var name            : String    = "NA"
    var logoUrl         : String?
    var duration        : String    = "NA"
    var last_purchase   : String    = "NA"
    var seconds         : Int       = 0
    var start_from      : String    = "NA"
    var rating          : String    = ""
    var popularity      : String    = ""
    var is_favourite     : Int = 0
    var isFavSeller     : Bool = false
    var is_available    : Int  = 0
    var name_arabic     : String = ""
    var is_delegate_available    : Int  = 0
    var delegate_available    : Int  = 1

    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        vendorId            <- map["vendor_id"]
        name                <- map["name"]
        logoUrl             <- map["logo"]
        duration            <- map["duration"]
        last_purchase       <- map["last_purchase"]
        seconds             <- map["seconds"]
        start_from          <- map["start_from"]
        rating              <- map["rating"]
        popularity          <- map["popularity"]
        is_favourite     <- map["is_favourite"]
        is_available     <- map["is_available"]
        name_arabic      <- map["name_arabic"]
        is_delegate_available            <- map["is_delegate_available"]
        delegate_available            <- map["delegate_available"]

    }
}

