///
//  EditProfileRespose.swift
//  Customer
//
//  Created by Priyanka Jagtap on 09/10/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//


import Foundation
import ObjectMapper

class ApplyCoupenRespose: BaseResponse {
    
//    var data : profileData?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
//        data <- map ["data"]
    }
}

