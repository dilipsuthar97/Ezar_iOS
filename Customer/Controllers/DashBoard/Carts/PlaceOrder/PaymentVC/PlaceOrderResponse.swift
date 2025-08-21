//
//  PaymentResponse.swift
//  Customer
//
//  Created by webwerks on 6/5/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class PlaceOrderResponse: BaseResponse {
    var data : PlaceOrderModel?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct PlaceOrderModel: Mappable {
    
    var message             : String        = ""
    var description         : String        = ""
    var orders              : [Orders]      = []
    var webview_url         : String        = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        message             <- map["message"]
        description         <- map["description"]
        orders              <- map["orders"]
        webview_url         <- map["webview_url"]
    }
}

struct Orders: Mappable {
    
    var order_id                : Int           = 0
    var delivery_date           : String        = ""
    var products                : [AllProducts]    = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        order_id            <- map["order_id"]
        delivery_date       <- map["delivery_date"]
        products            <- map["products"]
    }
}

struct AllProducts: Mappable {
    
    var title                : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        title           <- map["title"]
    }
}
