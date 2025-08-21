//
//  MeasurementTypeResponse.swift
//  Customer
//
//  Created by webwerks on 6/6/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

//class MeasurementTypeResponse: BaseResponse {
//    var data : [MesurementItems]?
//
//    required init?(map: Map){
//        super.init(map: map)
//    }
//
//    override func mapping(map: Map) {
//        super.mapping(map: map)
//        data <- map ["data.items"]
//    }
//}
//
//struct MesurementItems: Mappable {
//
//    var code        : String = ""
//    var title       : String = ""
//
//    init?(map: Map) {
//
//    }
//
//    // Mappable
//    mutating func mapping(map: Map) {
//
//        code            <- map["code"]
//        title           <- map["title"]
//    }
//}

class MeasurementTypeResponse: BaseResponse {
    var success : Bool?
 //   var code : Int?
    var data : MeasurementData?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        success <- map["success"]
//        code <- map["code"]
        data <- map["data"]
    }
}

struct MeasurementData : Mappable {
    var items : [MesurementItems]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        items <- map["items"]
    }
    
}

struct MesurementItems: Mappable {
    
    var id : String = ""
    var model_id : String = ""
    var model_label : String = ""
    var measurement_id : String = ""
    var measurement_label : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        model_id <- map["model_id"]
        model_label <- map["model_label"]
        measurement_id <- map["measurement_id"]
        measurement_label <- map["measurement_label"]
    }
}
