//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class MyRequestResponse: BaseResponse {
    
    var data :   [MyRequestList]?

    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data.my_request"]
    }
}


struct MyRequestList: Mappable {
    var request_id                  : Int?
    var delegate_id                 : Int?
    var delegate_name               : String  = ""
    var customer_name               : String = ""
    var delegate_profile_image      : String?
    var delegate_address            : String = ""
    var latitude                    : String = "" //Double = 0.00
    var longitude                   : String = "" //Double = 0.00
    var instructions                : String = ""
    var location_name               : String = ""
    var location_type               : String = ""
    var isExpired                   : Int?
    var status                      : String = ""

    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        request_id              <- map["request_id"]
        delegate_id             <- map["delegate_id"]
        delegate_name           <- map["delegate_name"]
        customer_name           <- map["customer_name"]
        delegate_profile_image  <- map["delegate_profile_image"]
        delegate_address        <- map["delegate_address"]
        latitude                <- map["latitude"]
        longitude               <- map["longitude"]
        instructions            <- map["request_instruction.instructions"]
        location_name           <- map["request_instruction.location_name"]
        location_type           <- map["request_instruction.location_type"]
        isExpired               <- map["isExpired"]
        status                  <- map["status"]

    }
}

