//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class SettingsResponse: BaseResponse {
    
    required init?(map: Map){
        super.init(map: map)
    }
 
}
class ChangePasswordResponse: BaseResponse {
    
    required init?(map: Map){
        super.init(map: map)
    }
    
}
