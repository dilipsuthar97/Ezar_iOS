///
//  OTPRespose.swift
//  Customer
//
//  Created by Priyanka Jagtap on 14/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//


import Foundation
import ObjectMapper

class OTPRespose: BaseResponse {
    
    var data : [Profile]?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}
