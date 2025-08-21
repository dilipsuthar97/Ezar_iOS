//
//  BroadCastResponse.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/29/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class BroadCastResponse : BaseResponse {

    var data : BroadCastListData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
    
        data <- map["data"]
    }
}

struct BroadCastListData : Mappable {
    var customer_id : String?
    var total_items : Int?
    var currency_symbol : String?
    var items : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        customer_id <- map["customer_id"]
        total_items <- map["total_items"]
        currency_symbol <- map["currency_symbol"]
        items <- map["items"]
    }
    
}
