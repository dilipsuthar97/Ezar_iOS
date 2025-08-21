//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class CuffStyleResponse: BaseResponse {
    
    var data : [ProductOption]?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data.options"]
    }
}

class ProductOption: Mappable {
    
    var main_option_id          : String                    = ""
    var title                   : String                    = ""
    var is_require              : String                    = ""
    var sort_order              : String                    = ""
    var values                  : [ProductOptionValues]     = []
    var oldValues                  : [ProductOptionValues]     = []
    var description             : String                    = ""
    
    required init?(map: Map) {
        
    }
    
    // Mappable
     func mapping(map: Map) {
        main_option_id      <- map["main_option_id"]
        title               <- map["title"]
        is_require          <- map["is_require"]
        sort_order          <- map["sort_order"]
        values              <- map["values"]
        oldValues              <- map["values"]
        description         <- map["description"]
    }
}
class ProductOptionValues: Mappable {
   
    var parent_option_id            : String = ""
    var option_id                   : String = ""
    var title                       : String = ""
    var sort_order                  : String = ""
    var description                 : String = ""
    var is_default                  : String = ""
    var images_data                 : [ProductOptionImageData] = []
    var field_hidden_dependency     : [ProductOptionFieldHiddenDependency] = []
    var isChecked                   : Bool = false
    var priceFormatted              : String = ""
    var priceNormal                 : Double = 0.0
    
    required init?(map: Map) {
        
    }
   
    // Mappable
     func mapping(map: Map) {
        parent_option_id                <- map["parent_option_id"]
        option_id                       <- map["option_id"]
        title                           <- map["title"]
        sort_order                      <- map["sort_order"]
        description                     <- map["description"]
        is_default                      <- map["is_default"]
        images_data                     <- map["images_data"]
        field_hidden_dependency         <- map["field_hidden_dependency"]
        priceFormatted                  <- map["price.formatted"]
        priceNormal                     <- map["price.normal"]
    }
}

struct ProductOptionImageData: Mappable {
    var url: String = ""
    var value: String = ""
    var title_text: String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        url                 <- map["url"]
        value               <- map["value"]
        title_text          <- map["title_text"]
    }
}

struct ProductOptionFieldHiddenDependency: Mappable {
    var child_option_id : String = ""
    var parent_option_id : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        child_option_id               <- map["child_option_id"]
        parent_option_id               <- map["parent_option_id"]
    }
}
