//
//  BodyFitResponse.swift
//  EZAR
//
//  Created by abc on 31/08/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class BodyFitResponse: BaseResponse {
    
   var data : FitData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        data <- map["data"]
    }
}
    class FitData : Mappable {
        var measurement_template_id : String?
        var measurement_template_name : String?
        var fit_options : [Fit_options_data]?

       required init?(map: Map) {

        }

         func mapping(map: Map) {

            measurement_template_id <- map["measurement_template_id"]
            measurement_template_name <- map["measurement_template_name"]
            fit_options <- map["fit_options"]
        }

    }
    
    class Fit_options_data : Mappable {
        var id : Int?
        var label : String?
        var show_label : String?
        var video_link : String?
        var video_link_arabic : String?

       required init?(map: Map) {

        }

        func mapping(map: Map) {
            id <- map["id"]
            label <- map["label"]
            show_label <- map["show_label"]
            video_link <- map["video_link"]
            video_link_arabic <- map["video_link_arabic"]
        }

    }


    
    
