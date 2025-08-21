//
//  ReviewListResponse.swift
//  Customer
//
//  Created by Priyanka Jagtap on 31/05/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class ReviewListResponse: BaseResponse {
    
    var data : Reviews?
        
        required init?(map: Map){
            super.init(map: map)
        }
        
        override func mapping(map: Map) {
        super.mapping(map: map)
            data <- map ["data.reviews"]
        }
}
