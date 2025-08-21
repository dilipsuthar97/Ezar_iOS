//
//  Keys.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

let MAINSCREEN = UIScreen.main.bounds
let dateFormate = "yyyy-MM-dd"
let delegateProductType = "T"
var globle_timer : Timer? = nil

struct keys {
    static let headerName = "admin"
    static let headerPassword = "admin321"
}

struct GOOGLE {
    static let DISTANCE_MATRIX_URL = "https://maps.googleapis.com/maps/api/distancematrix/json"
    static let DIRECTIONS_URL = "https://maps.googleapis.com/maps/api/directions/json?origin="
    static let NEARBYSEARCH_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
    static let PLACES_AUTOCOMPLETE_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
}

struct CONSTANT {
    static let latitude = 33.8688
    static let longitude = 151.2093
}
