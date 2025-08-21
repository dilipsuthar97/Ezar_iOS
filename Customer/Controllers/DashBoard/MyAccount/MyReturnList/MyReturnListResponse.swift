//
//  MyReturnListResponse.swift
//  Customer
//
//  Created by webwerks on 11/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class MyReturnListResponse: BaseResponse {
    var data : [ReturnItems]?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data.return_items"]
    }
}

struct ReturnItems: Mappable
{
    var comment_count           : Int       = 0
    var request_id              : Int       = 0
    var request_increment_id    : String    = ""
    var order_incremental_id    : String    = ""
    var order_status            : String    = ""
    var state                   : String    = ""
    var status                  : String    = ""
    var created_at              : String    = ""
    var updated_at              : String    = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        comment_count           <- map["comment_count"]
        request_id              <- map["request_id"]
        request_increment_id    <- map["request_increment_id"]
        order_incremental_id    <- map["order_incremental_id"]
        order_status            <- map["order_status"]
        state                   <- map["state"]
        status                  <- map["status"]
        created_at              <- map["created_at"]
        updated_at              <- map["updated_at"]
    }
}
