//
//  OrderResponse.swift
//  Customer
//
//  Created by webwerks on 9/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderResponse: BaseResponse {
    var data : GetOrders?
    var allOrdersdata : OrdersData?

    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
        allOrdersdata <- map ["data"]

    }
}

struct GetOrders: Mappable {
    var custommadeOrders    : OrdersData?     = nil
    var readymadeOrders     : OrdersData?    =  nil
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        custommadeOrders    <- map["custommade"]
        readymadeOrders      <- map["readymade"]
        
    }
}

struct OrdersData: Mappable {
    var current_page   : Int = 0
    var page_count     : Int = 0
    var products      : [CustomReadyMadeOrder]   =  []
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        current_page    <- map["current_page"]
        page_count      <- map["page_count"]
        products        <- map["orders"]
    }
}


struct CustomReadyMadeOrder: Mappable {
    var order_id            : Int       = 0
    var order_increment_id  : Int       = 0
    var status              : String    = ""
    var no_of_products      : Int       = 0
    var total               : String    = ""
    var currency_symbol     : String    = ""
    var payment_mode        : String    = ""
    var description         : String    = ""
    var group               : String    = ""
    var delivery_date       : String    = ""
    var created_at          : String    = ""
    var updated_at          : String    = ""

    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        order_id            <- map["order_id"]
        order_increment_id  <- map["order_increment_id"]
        status              <- map["status"]
        no_of_products      <- map["no_of_products"]
        total               <- map["total"]
        currency_symbol     <- map["currency_symbol"]
        payment_mode        <- map["payment_mode"]
        description         <- map["description"]
        group               <- map["group"]
        delivery_date       <- map["delivery_date"]
        created_at          <- map["created_at"]
        updated_at          <- map["updated_at"]
    }
}
