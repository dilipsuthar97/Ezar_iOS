//
//  PrivacyPolicyResponse.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/22/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class PrivacyPolicyResponse: BaseResponse {
    
    var data : PrivayPolicyData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        data <- map["data"]
    }
    
}

struct PrivayPolicyData : Mappable {
    var privayPolicy : [PrivayPolicy]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        privayPolicy <- map["privacy-policy"]
    }
    
}

struct PrivayPolicy : Mappable {
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

