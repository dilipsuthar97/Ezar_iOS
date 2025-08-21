//
//  NearestDelegateResponse.swift
//  Customer
//
//  Created by webwerks on 7/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class DelegateDetailResponse: BaseResponse
{
    var data : DelegateDetail?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

struct DelegateDetail: Mappable {
    
    var delegate_id     : Int    = 0
    var delegate_lat    : String = ""
    var delegate_lon    : String = ""
    var duration        : String = "NA"
    var name            : String = ""
    var profile_image   : String?
    var rating          : String    = ""
    var request_id      : Int = 0
    var sRequest_id      : String = ""
    var mobile_number   : String = ""
    var country_code     : String = ""

    var request_for     : [String] = []
    var request_instruction       : RequestInstruction?
    var status        : String = ""
    var reviewRating    : ReviewRating? = nil
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        delegate_id         <- map["delegate_id"]
        delegate_lat        <- map["delegate_latitude"]
        delegate_lon        <- map["delegate_longitude"]
        duration            <- map["duration"]
        name                <- map["name"]
        profile_image       <- map["profile_image"]
        rating              <- map["rating"]
        request_id          <- map["request_id"]
        sRequest_id         <- map["request_id"]
        request_for             <- map["request_for"]
        request_instruction     <- map["request_instruction"]
        mobile_number             <- map["contact_number"]
        status               <- map["status"]
        country_code             <- map["country_code"]
        reviewRating             <- map["review_and_ratings"]

    }
}


