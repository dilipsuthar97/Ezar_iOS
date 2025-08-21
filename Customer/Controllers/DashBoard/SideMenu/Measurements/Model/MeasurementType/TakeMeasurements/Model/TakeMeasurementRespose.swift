//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class TakeMeasurementRespose: BaseResponse {
    
    var data : MeasurementIDModel?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct MeasurementIDModel: Mappable {
    
    var measurement_id         : String = ""
    
    init?(map: Map) {
        
    }
    // Mappable
    mutating func mapping(map: Map) {
        
        measurement_id             <- map["measurement_id"]
    }
}
