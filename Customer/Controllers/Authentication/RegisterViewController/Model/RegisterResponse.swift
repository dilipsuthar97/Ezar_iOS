//
//  RegisterResponse.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class RegisterResponse: BaseResponse {
    
   var data : registerData?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
      data <- map ["data"]
    }
}

struct registerData : Mappable {
    var login_type : String?
    var user : Profile?


    init?(map: Map) {
    }

   mutating func mapping(map: Map) {
          login_type <- map ["login_type"]
          user <- map ["user"]

    }
}

