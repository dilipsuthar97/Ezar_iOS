//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class HelpResponse: BaseResponse {
    
    var data : [HelpDetails]?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data.helps"]
    }
}

struct HelpDetails: Mappable {
    
    var topic          : String           = ""
    var description            : String?
    var isRowExpanded     : Int = -1

    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        topic                 <- map["topic"]
        description           <- map["description"]
   }
}
