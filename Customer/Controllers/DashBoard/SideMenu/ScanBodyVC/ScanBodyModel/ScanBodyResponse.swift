//
//  ScanBodyResponse.swift
//  EZAR
//
//  Created by abc on 15/07/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class ScanBodyResponse: BaseResponse {
   
    var data : ScanData?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
        
    }
}

struct ScanData : Mappable {
    var men : Men?
    var women : Women?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        men <- map["men"]
        women <- map["women"]
    }

}
struct Men : Mappable {
    var english : String?
    var arabic : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        english <- map["english"]
        arabic <- map["arabic"]
    }

}
struct Women : Mappable {
    var english : String?
    var arabic : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        english <- map["english"]
        arabic <- map["arabic"]
    }

}
