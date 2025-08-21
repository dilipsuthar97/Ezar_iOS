//
//  RewardHistoryResponse.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/22/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import Foundation
import ObjectMapper

class RewardHistoryResponse : Mappable {
    
    var data : RewardHistoryData?
    var message : String?
    
    required init?(map: Map) {
        
    }
    
   func mapping(map: Map) {
        data     <- map["data"]
        message  <- map["message"]
    }
    
}

struct RewardHistoryData : Mappable {
    var available_balance : String?
    var list : [RewardHistoryList]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        available_balance <- map["available_balance"]
        list <- map["list"]
    }
    
}

struct RewardHistoryList : Mappable {
    var point : Int?
    var transaction_type : String = ""
    var description : String = ""
    var balance : Int?
    var created_at : String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        point <- map["point"]
        transaction_type <- map["transaction_type"]
        description <- map["description"]
        balance <- map["balance"]
        created_at <- map["created_at"]
    }
    
}
