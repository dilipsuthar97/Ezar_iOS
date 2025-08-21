//
//  TermsConditionScannerResponse.swift
//  EZAR
//
//  Created by abc on 16/07/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class TermsConditionScannerResponse: BaseResponse {
    
    var data : ScannerData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        data <- map["data"]
    }
    
}

struct ScannerData : Mappable {
    var tearmsConditions : [TearmsConditionsScanner]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        tearmsConditions <- map["terms-and-condition-for-body-scanner"]
    }
    
}

struct TearmsConditionsScanner : Mappable {
    var title : String?
    var identifier : String?
    var content : String?
    var content_heading : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title <- map["title"]
        identifier <- map["identifier"]
        content <- map["content"]
        content_heading <- map["content_heading"]
    }
    
}
