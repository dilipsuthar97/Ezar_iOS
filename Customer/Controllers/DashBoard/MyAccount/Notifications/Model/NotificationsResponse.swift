//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class NotificationsResponse: BaseResponse {
    
    var data : [NotificationDetails]?
    var unread_notification : Int = 0
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data.list"]
        unread_notification <- map["unread_notification"]
    }
}

struct NotificationDetails: Mappable {
    
    var notification_id     : String =   ""
    var customer_id         : Int    =   0
    var title               : String =   ""
    var description         : String =   ""
    var image               : String =   ""
    var status              : String =   ""
    var read                : String =   ""
    var expired_on          : String =   ""
    var created_at          : String =   ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        notification_id     <- map ["notification_id"]
        customer_id         <- map ["customer_id"]
        title               <- map ["title"]
        description         <- map ["description"]
        image               <- map ["image"]
        status              <- map ["status"]
        read                <- map ["read"]
        expired_on          <- map ["expired_on"]
        created_at          <- map ["created_at"]
    }
}

