//
//  ReviewFeedbackResponse.swift
//  Customer
//
//  Created by webwerks on 9/20/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class ReviewFeedbackResponse: BaseResponse
{
    var data : AllReviewFeedback?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}
    

