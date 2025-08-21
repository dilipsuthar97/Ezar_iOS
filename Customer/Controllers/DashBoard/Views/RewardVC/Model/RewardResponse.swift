//
//  RewardResponse.swift
//  Customer
//
//  Created by webwerks on 9/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class RewardResponse: BaseResponse
{
    var data : Rewards?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct Rewards: Mappable
{
    var reward_point : String = "0"
    var currency : String = ""
    var conversion_rate : Int = 0
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        reward_point        <- map["reward_point"]
        currency            <- map["currency"]
        conversion_rate     <- map["conversion_rate"]
        
    }
}
