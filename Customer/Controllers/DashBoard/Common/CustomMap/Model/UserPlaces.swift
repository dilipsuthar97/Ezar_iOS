//
//  UserPlaces.swift
//  MapCurrentLocation
//
//  Created by Shruti Gupta on 1/3/20.
//  Copyright © 2020 com.neosofttech.payUPayment. All rights reserved.
//

import Foundation
import ObjectMapper


//MARK:- Response

class MyMustResponse: BaseResponse {
    
    var mustData : MustData?
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        mustData <- map ["data"]
    }
    
}

class MustData : Mappable {
    
    
    var mustList = [MustList]()
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        mustList <- map["musts"]
        
    }
}
class MustUserData: Mappable {
    
    var user_id : Int = 0
    var name = ""
    var picture : String?
    var isFollow : Bool?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        user_id <- map ["user_id"]
        name <- map ["name"]
        picture <- map ["picture"]
        isFollow <- map ["is_follow"]
        
    }
}
class MustList : Mappable {
    
    var locations : Locations?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {

        locations <- map["location"]
    }
}

class Locations :  Mappable {
    
    var latitude : Double = 0
    var longitude : Double = 0
    var name : String?
    var vicinity : String?
   
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        
        name <- map["name"]
        vicinity <- map["vicinity"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        
    }
}

