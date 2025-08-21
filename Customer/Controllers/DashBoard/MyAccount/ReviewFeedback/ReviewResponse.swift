//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class ReviewResponse: BaseResponse {
    
    var data : AllReviewFeedback?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct AllReviewFeedback: Mappable {
    
    var product_item_list   : ProductItemList?
    var seller_list         : ManufacturerList?
    var delegate_list       : DelegateList?
    var review_format       : ReviewFormat?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        product_item_list    <- map["product_list"]
        seller_list          <- map["seller_list"]
        delegate_list        <- map["delegate_list"]
        review_format        <- map["review_format"]
    }
}

struct ProductItemList: Mappable {
    
    var page_count          : Int = 0
    var current_page        : Int = 0
    var product_list        : [Products] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        page_count          <- map["page_count"]
        current_page        <- map["current_page"]
        product_list        <- map["list"]
    }
}

struct ManufacturerList: Mappable {
    
    var page_count          : Int = 0
    var current_page        : Int = 0
    var seller_list         : [ListItems] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        page_count          <- map["page_count"]
        current_page        <- map["current_page"]
        seller_list         <- map["list"]
    }
}

struct DelegateList: Mappable {
    
    var page_count          : Int = 0
    var current_page        : Int = 0
    var delegate_list       : [ListItems] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        page_count          <- map["page_count"]
        current_page        <- map["current_page"]
        delegate_list       <- map["list"]
    }
}

struct Products: Mappable {
    
    var id : Int = 0
    var product_id : Int = 0
    var vendor_id : Int = 0
    var order_increment_id : Int = 0
    var name : String = ""
    var payment_mode : String = ""
    var status : String = ""
    var updated_at : String = ""
    var price : String = ""
    var currency_symbol : String = ""
    var image : String = ""
    var product_type : String = ""
    var rating_and_reviews : RatingAndReviews?
    var order_status : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        id                      <- map["id"]
        product_id              <- map["product_id"]
        vendor_id               <- map["vendor_id"]
        order_increment_id      <- map["order_increment_id"]
        name                    <- map["name"]
        payment_mode            <- map["payment_mode"]
        status                  <- map["status"]
        updated_at              <- map["updated_at"]
        price                   <- map["price"]
        currency_symbol         <- map["currency_symbol"]
        image                   <- map["image"]
        rating_and_reviews      <- map["rating_and_reviews"]
        product_type            <- map["product_type"]
        order_status            <- map["order_status"]
    }
}

struct ListItems: Mappable {
    
    var id : Int = 0
    var name : String = ""
    var logo : String = ""
    var rating_and_reviews : RatingAndReviews?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        id                      <- map["id"]
        name                    <- map["name"]
        logo                    <- map["logo"]
        rating_and_reviews      <- map["rating_and_reviews"]
    }
}

struct RatingAndReviews: Mappable {
    
    var question_answers        : [ReviewQuestions] = []
    var rating                  : String = ""
    var review_description      : String = ""
    var review_id               : Int = 0
    var review_title            : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        question_answers        <- map["question_answers"]
        rating                  <- map["rating"]
        review_description      <- map["review_description"]
        review_id               <- map["review_id"]
        review_title            <- map["review_title"]
    }
}

struct QuestionAnswer : Mappable {
    var question_id : String?
    var option_values : [String]?
    var type : String?
    var question : String?
    var answer : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        question_id <- map["question_id"]
        option_values <- map["option_values"]
        type <- map["type"]
        question <- map["question"]
        answer <- map["answer"]
    }
    
}


struct ReviewFormat: Mappable {
    
    var delegate        : [ReviewQuestions] = []
    var fabric          : [ReviewQuestions] = []
    var product         : [ReviewQuestions] = []
    var seller          : [ReviewQuestions] = []
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        delegate        <- map["delegate"]
        fabric          <- map["fabric"]
        product         <- map["product"]
        seller          <- map["seller"]
    }
}

struct ReviewQuestions: Mappable {
    
    var option_values   : [String] = []
    var question        : String = ""
    var question_id     : String = ""
    var type            : String = ""
    var answer          : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        
        option_values   <- map["option_values"]
        question        <- map["question"]
        question_id     <- map["question_id"]
        type            <- map["type"]
        answer          <- map["answer"]
    }
}


