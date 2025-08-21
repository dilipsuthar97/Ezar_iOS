//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class FAQsResponse: BaseResponse {
    
    var data : [FaqDetails]?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data.faqs"]
    }
}

struct FaqDetails: Mappable {
    
    var question          : String           = ""
    var answer            : String?
    var isRowExpanded     : Int = -1

    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        question             <- map["question"]
        answer               <- map["answer"]
   }
}
