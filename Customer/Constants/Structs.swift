//
//  Structs.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

struct Headers {
    let ContentType: String
    let Accept: String
    let cache: String
}

public struct HEADERS {
    static let urlEncoded = Headers(ContentType: "application/x-www-form-urlencoded; charset=UTF-8", Accept: "application/json; charset=UTF-8", cache: "no-cache")
    static let appJson = Headers(ContentType: "application/json; charset=UTF-8", Accept: "application/json; charset=UTF-8", cache: "no-cache")
    static let multipart = Headers(ContentType: "multipart/form-data", Accept: "application/json; charset=UTF-8", cache: "no-cache")
}

struct LocalNotification {
    static let GoogleSignIn = "GoogleSignIn"
    static let InternetConnectionOff = "InternetConnectionOff"
    static let InternetConnectionOn = "InternetConnectionOn"
}


struct GoogleKeys {
    
    //New Generated Key ----
    static let placesKey = "AIzaSyCzMSyG6pQhJZKJKPs_ZBv3kL4SwucrsTU"
    static let delegatePlacesKey = "AIzaSyAGUR94Sfy5D-6oJj0bmUbk_b_1u-lyohI"
    
    //Google Sign IN
    static let customerSignInKey = "125857722951-3ogbqq6076rf2u4bgjt0p3fr6hbs3v85.apps.googleusercontent.com"
    static let delegateSignInKey = "1018269970055-fol3m982rafasjhg35trnmnlsicvkace.apps.googleusercontent.com"
}

struct FavoriteTabs {
    static let products = "PRODUCTS"
    static let manufacturer = "MANUFACTURER"
    static let delegate = "DELEGATE"
}

struct FAVORITE_INDEX {
    static let products = 0
    static let manufacturer     = 1
    static let delegate     = 2
}

struct SelectModelTabs {
    static let saudi = "Saudi Thobe"
    static let uae = "UAE Thobe"
    static let qatari = "Qatari Thobe"
    static let qata = "Qata Thobe"
}

struct OrderTabs {
    static let all = "ALL"
    static let readymade = "READY MADE"
    static let custommade = "CUSTOM MADE"
}


struct ORDER_INDEX {
    static let all   =  0
    static let readymade = 1
    static let custommade     = 2
}

struct UniversalLinkValues {
    var NAME = ""
    var ID = ""
    var APP_MODE = ""
    var CATEGORY_ID = ""
}

struct ObjData {
    let title: String
    let details: String
    let key: Int
}

struct keyValueData {
    let title: String
    let key: Int
}

struct ImgObjData {
    let title: String
    let details: String = ""
    let image: UIImage?
    let key: Int
}

