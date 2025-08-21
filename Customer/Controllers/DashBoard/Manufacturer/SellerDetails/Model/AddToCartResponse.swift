//
//  AddToCartResponse.swift
//  EZAR
//
//  Created by abc on 28/05/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class AddToCartResponse :BaseResponse{
   
    var data : AddToCartData?

    required init?(map: Map){
        super.init(map: map)
    }

     override func mapping(map: Map) {
            super.mapping(map: map)

        data <- map["data"]

    }
    
    struct AddToCartData : Mappable {
        var quote_id : String?
        var cart_count : Int?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            quote_id <- map["quote_id"]
            cart_count <- map["cart_count"]
        }

    }

}
