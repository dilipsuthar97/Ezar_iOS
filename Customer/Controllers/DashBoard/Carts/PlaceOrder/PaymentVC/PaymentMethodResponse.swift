//
//  PaymentMethodResponse.swift
//  Customer
//
//  Created by webwerks on 6/5/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentMethodResponse: BaseResponse {
    var data : PaymentMethod?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct PaymentMethod: Mappable {
    
    var conversion_rate         : Int = -1
    var converted_amount        : Int = -1
    var currency                : String = ""
    var customer_reward_points  : String = ""
    var methods                 : Methods?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        conversion_rate             <- map["conversion_rate"]
        converted_amount            <- map["converted_amount"]
        currency                    <- map["currency"]
        customer_reward_points      <- map["customer_reward_points"]
        methods                     <- map["methods"]
    }
}

struct Methods: Mappable {
    
    var offline             : [OfflineMethods]      = []
    var online              : [OnlineMethods]      = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        offline             <- map["offline"]
        online              <- map["online"]
    }
}



struct OfflineMethods: Mappable {
    
    var code                : String      = ""
    var title               : String      = ""
    var description         : String      = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        code                    <- map["code"]
        title                   <- map["title"]
        description             <- map["description"]
    }
}

struct OnlineMethods: Mappable {
    
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
    }
}
