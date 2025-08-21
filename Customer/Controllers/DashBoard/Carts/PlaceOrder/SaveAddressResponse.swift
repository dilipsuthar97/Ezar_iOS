//
//  SaveAddressResponse.swift
//  Customer
//
//  Created by webwerks on 9/26/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class SaveAddressResponse: BaseResponse
{
    var data : [AddressList]?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data.address"]
    }
}

struct AddressList: Mappable {
    var address_id          :Int = 0
    var street              : String = ""
    var city                : String = ""
    var mobile_number       : String = ""
    var latitude            : String = ""
    var longitude           : String = ""
    var is_default          : Int = 0
    var country_code        : String = ""
    var country_name        : String = ""
    var delivery_instruction   : String = ""
    var is_new              : Int = 1
    var location_type       : String = ""
    var name                : String = ""
    var postcode           : String = ""
    var region              : String = ""
    var country              : String = ""


    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        address_id          <- map["id"]
        street              <- map["street"]
        city                <- map["city"]
        mobile_number       <- map["mobile_number"]
        latitude            <- map["latitude"]
        longitude           <- map["longitude"]
        is_default           <- map["is_default"]
        country_code         <- map["country_code"]
        country_name          <- map["country_name"]
        delivery_instruction   <- map["delivery_instruction"]
        is_new                 <- map["is_new"]
        location_type         <- map["location_type"]
        name                  <- map["name"]
        postcode              <- map["postcode"]
        region                <- map["region"]
        country                <- map["country"]
    }
}



