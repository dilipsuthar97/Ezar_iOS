//
//  MyReturnsResponse.swift
//  Customer
//
//  Created by webwerks on 11/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class MyReturnsResponse: BaseResponse {
    var data : ReturnDetails?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct ReturnDetails: Mappable
{
    var request_id              : String            = ""
    var increment_id            : String            = ""
    var customer_id             : String            = ""
    var order_incremental_id    : String            = ""
    var order_created_at        : String            = ""
    var order_status            : String            = ""
    var order_status_label      : String            = ""
    var currency_symbol         : String            = ""
    var status                  : String            = ""
    var state                   : String            = ""
    var created_at              : String            = ""
    var updated_at              : String            = ""
    var items                   : [ReturnItemLists] = []
    var messages                : [ReturnMessage]   = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        request_id              <- map["request_id"]
        increment_id            <- map["increment_id"]
        customer_id             <- map["customer_id"]
        order_incremental_id    <- map["order_incremental_id"]
        order_created_at        <- map["order_created_at"]
        order_status            <- map["order_status"]
        order_status_label      <- map["order_status_label"]
        currency_symbol         <- map["currency_symbol"]
        status                  <- map["status"]
        state                   <- map["state"]
        created_at              <- map["created_at"]
        updated_at              <- map["updated_at"]
        items                   <- map["items"]
        messages                <- map["messages"]
    }
}

struct ReturnItemLists : Mappable
{
    var order_item_id       : Int               = 0
    var return_item_id      : Int               = 0
    var return_qty          : Int               = 0
    var product_id          : Int               = 0
    var name                : String            = ""
    var sku                 : String            = ""
    var image               : String            = ""
    var final_price         : Int               = 0
    var original_price      : Int               = 0
    var per_off             : Int               = 0
    var row_total           : Int               = 0
    var extra_info          : ReturnExtraInfo?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map)
    {
        order_item_id       <- map["order_item_id"]
        return_item_id      <- map["return_item_id"]
        return_qty          <- map["return_qty"]
        product_id          <- map["product_id"]
        name                <- map["name"]
        sku                 <- map["sku"]
        image               <- map["image"]
        final_price         <- map["final_price"]
        original_price      <- map["original_price"]
        per_off             <- map["per_off"]
        row_total           <- map["row_total"]
        extra_info          <- map["extra_info"]
    }
}

struct ReturnExtraInfo : Mappable
{
    var simple_name         : String                    = ""
    var simple_sku          : String                    = ""
    var attributes_info     : [AttributesInfo]          = []
    var style_selection     : [ReturnStyleSelection]    = []
    var measurements        : [ReturnMeasurements]      = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map)
    {
        simple_name         <- map["simple_name"]
        simple_sku          <- map["simple_sku"]
        attributes_info     <- map["attributes_info"]
        style_selection     <- map["additional_options.style_selection"]
        measurements        <- map["additional_options.measurements"]
    }
}

struct ReturnStyleSelection : Mappable
{
    var label   : String = ""
    var value   : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map)
    {
        label   <- map["label"]
        value   <- map["value"]
    }
}

struct ReturnMeasurements : Mappable
{
    var label   : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map)
    {
        label   <- map["label"]
    }
}

struct ReturnMessage : Mappable
{
    var message_id  : String = ""
    var message     : String = ""
    var type        : String = ""
    var from        : String = ""
    var to          : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map)
    {
        message_id  <- map["message_id"]
        message     <- map["message"]
        type        <- map["type"]
        from        <- map["from"]
        to          <- map["to"]
    }
}



