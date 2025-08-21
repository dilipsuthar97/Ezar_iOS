//
//  BaseResponse.swift
//  ProgramingHub
//
//  Created by webwerks on 08/01/18.
//  Copyright © 2017 webwerks. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseResponse: Mappable {
    
    var status  : Bool?
    var code  : Int?
    var message : String?
    
    init() {

    }
    
    required init?(map: Map) {
   }
    
    // Mappable
    
    func mapping(map: Map) {
        status      <- map["success"]
        code          <- map["code"]
        message       <- map["message"]
    }
}
