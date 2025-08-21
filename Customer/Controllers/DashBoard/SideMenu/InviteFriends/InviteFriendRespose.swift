//
//  InviteFriendRespose.swift
//  Customer
//
//  Created by webwerks on 12/12/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class InviteFriendRespose: BaseResponse
{
    var data : InviteFriendData?
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

struct InviteFriendData: Mappable {
    
    var url : String = ""
    var referral_code : String = ""

    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        url     <- map["url"]
        referral_code     <- map["referral_code"]
    }
}
