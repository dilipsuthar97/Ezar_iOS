//
//  Profile.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper



class Profile : NSObject,NSCoding, Mappable{
    var id              : Int?
    var email           : String = ""
    var name            : String = ""
    var customerId      : Int?
    var cart_count      : Int?
    var quoteId         : Int?
    var password        : String?
    var profileImg      : String?
    var mobileNo        : String?
    var address         : String?
    var dob             : String = ""
    var city            : String = ""
    var country         : String = ""
    var is_forgot       : Int?
    var country_code    : String = ""
    var notification_count : Int?
    var whatsapp_us : String = ""
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id              <- map["id"]
        email           <- map["email"]
        name            <- map["name"]
        cart_count      <- map["cart_count"]
        quoteId         <- map["quoteId"]
        password        <- map["password"]
        profileImg      <- map["profile_image"]
        mobileNo        <- map["mobile_number"]
        dob             <- map["dob"]
        city            <- map["city"]
        country         <- map["country"]
        is_forgot       <- map["is_forgot"]
        country_code    <- map["country_code"]
        notification_count <- map ["notification_count"]
        whatsapp_us       <- map["whatsapp_us"]
    }
    
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObject(forKey: "ID") as? Int
        self.email = decoder.decodeObject(forKey: "EMAIL") as? String ?? ""
        self.password = decoder.decodeObject(forKey: "PASSWORD") as? String ?? ""
        self.name = decoder.decodeObject(forKey: "NAME") as? String ?? ""
        self.cart_count = decoder.decodeObject(forKey: "CART_COUNT") as? Int
        self.quoteId = decoder.decodeObject(forKey: "QUOTE_ID")as? Int
       self.profileImg = decoder.decodeObject(forKey: "PROFILE_IMG") as? String ?? ""
        self.mobileNo = decoder.decodeObject(forKey: "MOBILE_NUMBER") as? String ?? ""
        self.address = decoder.decodeObject(forKey: "ADDRESS") as? String ?? ""
        self.dob = decoder.decodeObject(forKey: "DOB") as? String ?? ""
        self.city = decoder.decodeObject(forKey: "CITY") as? String ?? ""
        self.country = decoder.decodeObject(forKey: "COUNTRY") as? String ?? ""
        self.is_forgot = decoder.decodeObject(forKey: "IS_FORGOT") as? Int
        self.country_code = decoder.decodeObject(forKey: "COUNTRY_CODE") as? String ?? ""
        self.notification_count = decoder.decodeObject(forKey: "NOTIFICATION_COUNT") as? Int
        self.whatsapp_us = decoder.decodeObject(forKey: "WHATSAPP_US") as? String ?? ""
    }
   
    func encode(with aCoder: NSCoder) {
        //Encode properties, other class variables, etc
        aCoder.encode(id, forKey: "ID")
        aCoder.encode(email , forKey: "EMAIL")
        aCoder.encode(password , forKey: "PASSWORD")
        aCoder.encode(name , forKey: "NAME")
        aCoder.encode(cart_count ?? "", forKey: "CART_COUNT")
        aCoder.encode(quoteId, forKey: "QUOTE_ID")
        aCoder.encode(profileImg, forKey: "PROFILE_IMG")
        aCoder.encode(mobileNo, forKey: "MOBILE_NUMBER")
        aCoder.encode(address, forKey: "ADDRESS")
        aCoder.encode(dob, forKey: "DOB")
        aCoder.encode(city, forKey: "CITY")
        aCoder.encode(country, forKey: "COUNTRY")
        aCoder.encode(is_forgot, forKey: "IS_FORGOT")
        aCoder.encode(country_code, forKey: "COUNTRY_CODE")
        aCoder.encode(notification_count, forKey: "NOTIFICATION_COUNT")
        aCoder.encode(whatsapp_us, forKey: "WHATSAPP_US")

    }
    
    class func save(_ object: Profile) {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
        let defaults = UserDefaults.standard
        defaults.set(encodedObject, forKey: "PROFILE")
        defaults.synchronize()
    }
    
    class func removeProfile() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "PROFILE")
        defaults.synchronize()
    }
    
    class func removeInviteLink() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "referral_code")
        defaults.removeObject(forKey: "share_link")
        defaults.synchronize()
    }

    
    class func loadProfile() -> Profile? {
        let defaults = UserDefaults.standard
        let encodedObject: Data? = defaults.object(forKey: "PROFILE") as! Data?
        if let data = encodedObject{
            let object: Profile? = NSKeyedUnarchiver.unarchiveObject(with: data) as? Profile
            return object
        }
        return nil
    }
}

