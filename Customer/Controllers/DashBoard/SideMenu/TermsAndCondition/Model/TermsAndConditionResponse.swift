//
//  TermsAndConditionResponse.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/3/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class TermsAndConditionResponse: BaseResponse {
    
    var data : CMSData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        data <- map["data"]
    }
    
}

struct CMSData : Mappable {
    var tearmsConditions : [TearmsConditions]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        tearmsConditions <- map["tearms-conditions"]
    }
    
}

struct TearmsConditions : Mappable {
    var title : String?
    var identifier : String?
    var content : String?
    var content_heading : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title <- map["title"]
        identifier <- map["identifier"]
        content <- map["content"]
        content_heading <- map["content_heading"]
    }
    
}
