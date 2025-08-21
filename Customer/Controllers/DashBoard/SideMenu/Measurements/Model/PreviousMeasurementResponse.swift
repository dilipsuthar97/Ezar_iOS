//
//  PreviousMeasurementResponse.swift
//  Customer
//
//  Created by webwerks on 5/25/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class PreviousMeasurementResponse: BaseResponse
{
    var data : [PreviousMeasurementData]?
    var meesage : String = ""
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data.measurements"]
        message <- map ["message"]
    }
}

struct PreviousMeasurementData: Mappable
{
    var measurement_id                  : String                = ""
    var title                           : String                = ""
    var height                          : String                = ""
    var weight                          : String                = ""
    var collar                          : String                = ""
    var measurement_type                : String                = ""
    var measurement_Info                : [NEMeasurementInfo]     = []
    var selected_type_type              : String                = ""
    var selected_type_color             : String                = ""
    var selected_type_key               : String                = ""
    var created_at                      : String                = ""
    var updated_at                      : String                = ""
    var model_type                      : String                = ""
    var measure_by                      : String                = ""

    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        measure_by                      <- map["measure_by"]
        measurement_id                  <- map["measurement_id"]
        title                           <- map["title"]
        height                          <- map["height"]
        weight                          <- map["weight"]
        collar                          <- map["collar"]
        measurement_type                <- map["measurement_type"]
        measurement_Info                <- map["measurement_info"]
        selected_type_type              <- map["selected_type.type"]
        selected_type_color             <- map["selected_type.color"]
        selected_type_key               <- map["selected_type.key"]
        created_at                       <- map["created_at"]
        updated_at                      <- map["updated_at"]
        model_type                      <- map["model_type"]

    }
}

struct MeasurementInfo: Mappable
{
    var option_id      : String        = ""
    var size           : String        = ""
    var title          : String        = ""
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        option_id                  <- map["option_id"]
        size                       <- map["size"]
        title                      <- map["title"]
    }
}

struct NEMeasurementInfo: Mappable
{
    var name      : String        = ""
    var value     : Double        = 0.0
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        name                  <- map["Name"]
        value                 <- map["Value"]
    }
}
