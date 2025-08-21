///
//  EditProfileRespose.swift
//  Customer
//
//  Created by Priyanka Jagtap on 14/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//


import Foundation
import ObjectMapper

class EditProfileRespose: BaseResponse {
    
    var data : profileData?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct profileData  : Mappable {
     var profileImage : String?
     var name : String = ""
     var email : String?
     var mobile_number : String?
     var dob : String = ""
    var city : String = ""
    var country : String = ""
    var country_code : String = ""

    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        profileImage <- map ["profile_image"]
        name <- map ["name"]
        email <- map ["email"]
        mobile_number <- map ["mobile_number"]
        dob <- map ["dob"]
        city <- map ["city"]
        country <- map ["country"]
        country_code <- map ["country_code"]
    }
}
