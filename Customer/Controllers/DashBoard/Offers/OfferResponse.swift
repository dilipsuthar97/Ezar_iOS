//
//  OfferResponse.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/22/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class OfferResponse: BaseResponse {
    
    var data : OfferData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        data <- map["data"]
    }
    
}

struct OfferData : Mappable {
    var offer : [Offer]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        offer <- map["offer"]
    }
    
}

struct Offer : Mappable {
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
