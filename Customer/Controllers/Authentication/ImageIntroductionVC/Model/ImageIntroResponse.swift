//
//  ImageIntroResponse.swift
//  EZAR
//
//  Created by Shruti Gupta on 2/14/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class ImageIntroResponse: BaseResponse {
    
    var data : IntroImageData?
    var codeValue : Int?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        
        data <- map["data"]
        codeValue <- map["code"]
    }
    
}

struct IntroImageData : Mappable {
    var list : [List]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        list <- map["list"]
    }
    
}

struct List : Mappable {
    var title : String?
    var image : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title <- map["title"]
        image <- map["image"]
    }
    
}
