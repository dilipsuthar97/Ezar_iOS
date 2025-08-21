//
//  ProfileResponse.swift
//  Customer
//
//  Created by webwerks on 5/18/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class ProfileResponse: BaseResponse
{
    var data : MyAccountDetails?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct MyAccountDetails: Mappable {
    
    var name            : String = ""
    var email           : String = ""
    var mobile_number   : String = ""
    var profile_image   : String?
    var address         : String = ""
    var dob             : String = ""
    var city            : String = ""
    var country         : String = ""
    var country_code    : String = ""
    var notification_count : Int = 0
    var whatsapp_us : String = ""

    init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        name                <- map["name"]
        email               <- map["email"]
        mobile_number       <- map["mobile_number"]
        profile_image       <- map["profile_image"]
        address             <- map["address"]
        dob                 <- map["dob"]
        city                <- map["city"]
        country             <- map["country"]
        country_code        <- map["country_code"]
        notification_count  <- map["notification_count"]
        whatsapp_us       <- map["whatsapp_us"]
    }
}
