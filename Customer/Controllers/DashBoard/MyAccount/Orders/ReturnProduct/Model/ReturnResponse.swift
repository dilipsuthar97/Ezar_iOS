//
//  ReturnResponse.swift
//  
//
//  Created by webwerks on 11/1/18.
//

import UIKit
import ObjectMapper

class ReturnResponse: BaseResponse {
    //var data : profileData?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        //        data <- map ["data"]
    }
}

