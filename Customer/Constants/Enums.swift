//
//  Enums.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

enum NetworkEnvironment: String {
    case development
    case production
    case sataging
}

enum Result<T> {
    case success(T)
    case error(RestError)
    case JSONParsingFailure
}

enum WebUrl: String {
    case terms_service = ""
    case privacy_policy = "1"

    var key: String {
        return rawValue
    }
}

enum WebTitle: String {
    case terms_service = "Terms of service"
    case privacy_policy = "Privacy policy"
    
    var key: String {
        return rawValue
    }
}


public enum GenderSelectionAllowed : Int {
    case Allowed = 1
    case NotAllowed = 0
}

public enum ProductTypeSelectionAllowed : Int {
    case Allowed = 1
    case NotAllowed = 0
}

public enum OwnFabricSelectionAllowed : Int {
    case Allowed = 1
    case NotAllowed = 0
}

public enum ScanBodyMeasurementSelectionAllowed : Int {
    case Allowed = 1
    case NotAllowed = 0
}

public enum MyTailorMeasurementSelectionAllowed : Int {
    case Allowed = 1
    case NotAllowed = 0
}

public enum MyPreviousMeasurementSelectionAllowed : Int {
    case Allowed = 1
    case NotAllowed = 0
}

public enum OrderStatus : String
{
    case NONE = "NONE"
    case PENDING = "PENDING"
    case PROCESSING = "PROCESSING"
    case SHIPPED = "SHIPPED"
    case DELIVERED = "DELIVERED"
    case CANCELED = "CANCELED"
}

public enum DetailClassType {
    case CHOOSESTYLE
    case ADDTOBAG
    case ADDTOCART
    case READYMADE
}

public enum SocialType : String {
    case NORMAL = "normal"
    case GOOGLE = "google"
    case FACEBOOK = "facebook"
    case APPLE = "apple"
}

public enum GenderSelection : Int
{
    case NONE = 1
    case WOMEN = 2
    case MEN = 3
    case WOMENREADYMADE = 44
    case MENREADYMADE = 43
    
    public static let allValues = ["NONE", TITLE.Women, TITLE.Men]
}

public enum MeasurementSelection : String
{
    case Text = "1"
    case Dropdown = "2"
    case Image = "3"
    case blank = ""
    
}

public enum LanguageSelection : Int {
    case ENGLISH = 1
    case ARABIC = 2
    public static let allValues = [TITLE.English, TITLE.Arabic]
}


public enum ProductType : String {
    case ReadyMade = "R"
    case CustomMade = "T"
    case All = ""
}

public enum ProductTypeOrder : String {
    case all = "ALL"
    case readymade = "READY MADE"
    case  customMade = "CUSTOM MADE"
}

public enum RequestType {
    case Pending
    case Approved
}

public enum RequestStatus : String {
    case Rejected  = "rejected"
    case Approved  = "approved"
    case Arrived   = "arrived"
    case Cancelled = "cancelled"
}

public enum FilterSortClassType {
    case NONE
    case PRODUCTSVC
    case NEARESTDELEGATEVC
    case CHOOSEFABRICVC
    case CUFFSTYLEVC
    case MANUFACTURESARCHLISTVC
    case TAILOREPRODUCTVC
}

public enum ReviewType : String {
    case Product  = "p"
    case Seller  = "s"
    case Delegate   = "d"
    case Fabric = "f"
}

public enum ReviewQuestionType : String
{
    case Yes_No = "Yes/No"
    case TextArea = "Textarea"
    case Text = "Text"
    case Select = "Select"
    
}

public enum SearchType : String
{
    case NONE
    case HOMESEARCH
    case MANUFACTURERSEARCH
    case PRODUCTSVC
    case CHOOSEFABRIC
}

public enum ClassType : String
{
    case NONE = "None"
    case PRODUCTSVC = "ProductsVC"
    case CHOOSEFABRICVC = "ChooseFabricVC"
    case CUFFSTYLEVC = "CuffStyleVC"
    case HOMEREQUESTSVC = "HomeRequestsVC"
    case MANUFACTURESEARCHLISTVC = "ManufactureSearchListVC"
    case SELECTMODELROOTVC = "SelectModelRootVC"
    case SELECTMODELVC = "SelectModelVC"
    case SHOPPINGBAGVC = "ShoppingBagVC"
}

public enum UniversalLinkVariable : String
{
    case NONE = "None"
    case NAME = "name"
    case ID = "id"
    case APP_MODE = "app_mode"
    case CATEGORY_ID = "category_id"
}

enum RequestDelegateStatus : String {
    case none = ""
    case pending = "pending"
    case approved = "approved"
    
    var key: String {
        return rawValue
    }
}


enum DelegateRequestType : String {
    case fabric = "fabric"
    case measurement = "measurement"
    
    var key: String {
        return rawValue
    }
}

enum SelectFabricStatus : Int {
    case fabricOnline = 0
    case contactDelegate = 1
    case myOwnFabric = 2

    var key: Int {
        return rawValue
    }
}

enum SelectMeasurementStatus : Int {
    case previousMeasurement = 0
    case requestDelegate = 1
    case scanBody = 2
    case tailorMeasurement = 3

    var key: Int {
        return rawValue
    }
}












enum SideMenuIndex : Int {
    case login = 0
    case profile = 1
    case home = 2
    case my_account = 3
    case measurements = 4
    case scanIntro = 5
    case settings = 6
    case termsAndCondition = 7
    case privacy_policy = 8
    case offer = 9
    case help = 10
    case whatsApp_us = 11
    case invite_friends = 12

    var key: Int {
        return rawValue
    }
}
