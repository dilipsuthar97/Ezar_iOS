//
//  LandingResponse.swift
//  EZAR
//
//  Created by The Appineers on 22/03/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper


class LandingResponse: BaseResponse
{
    var data : ConfigurationData?
    var meesage : String = ""
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
        message <- map ["message"]
    }
}

struct ConfigurationData : Mappable
{
    var own_fabrics                  : Int = 0
    var my_tailor_measurements       : Int = 0
    var my_previous_measurements     : Int = 0
    var scan_body_measurements       : Int = 0
    var men_woman                    : Int = 0
    var readymade_custommade         : Int = 0
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        own_fabrics                <- map["own_fabrics"]
        my_tailor_measurements     <- map["my_tailor_measurements"]
        my_previous_measurements   <- map["my_previous_measurements"]
        scan_body_measurements     <- map["scan_body_measurements"]
        men_woman                  <- map["men_woman"]
        readymade_custommade       <- map["readymade_custommade"]
    }
}
