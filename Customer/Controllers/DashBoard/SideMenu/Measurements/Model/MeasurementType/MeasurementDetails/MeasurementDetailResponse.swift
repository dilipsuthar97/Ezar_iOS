//
//  MeasurementDetailResponse.swift
//  Customer
//
//  Created by webwerks on 6/4/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class MeasurementDetailResponse: BaseResponse {
    var data : MeasurementTemplate?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

class MeasurementTemplate: Mappable {
    
    var measurement_template_id         : String = ""
    var measurement_template_list       : [MeasurementTemplateList] = []
    var fitOptions                      : [FitOptions] = []
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        measurement_template_id             <- map["measurement_template_id"]
        measurement_template_list           <- map["options"]
        fitOptions                          <- map["fit_options"]
    }
}

class MeasurementTemplateList: Mappable {
    
    var measurement_option_id       : String = ""
    var title                       : String = ""
    var image                       : [String] = []
    var description                 : String = ""
    var video_link                  : String = ""
    var max_value                   : String = ""
    var min_value                   : String = ""
    var option_id_depend_on         : Int = 0
    var max_operator                : String = ""
    var min_operator                : String = ""
    var enterText                   : Double = 0.0
    
    var option_type                 : String = ""
    var dropdown_option             : [DropDownData]?
    var image_option                : [ImagesData]?

//    var isChecked                   : Bool = false
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        measurement_option_id       <- map["measurement_option_id"]
        title                       <- map["title"]
        image                       <- map["image"]
        description                 <- map["description"]
        video_link                  <- map["video_link"]
        max_value                  <- map["max_value"]
        min_value                  <- map["min_value"]
        option_id_depend_on        <- map["option_id_depend_on"]
        max_operator               <- map["max_operator"]
        min_operator               <- map["min_operator"]
        
        option_type                <- map["option_type"]
        dropdown_option            <- map["dropdown_option"]
        image_option               <- map["image_option"]

    }
}

class FitOptions: Mappable {
    
    var id       : Int = 0
    var label       : String = ""
    var show_label  : String = ""
    var video_link  : String = ""
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        id       <- map["id"]
        label       <- map["label"]
        show_label  <- map["show_label"]
        video_link  <- map["video_link"]
    }
}
    
    class ImagesData: Mappable {
        
        var title       : String = ""
        var path        : String = ""
        var key         : String = ""
        var isChecked   : Bool = false
        
        required init?(map: Map) {
            
        }
        
        // Mappable
        func mapping(map: Map) {
            
            title       <- map["title"]
            path        <- map["path"]
            key         <- map["key"]
        }
    }

class DropDownData: Mappable {
    
    var title         : String = ""
    var key           : String = ""
   
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        title          <- map["title"]
        key            <- map["key"]
    }
}

