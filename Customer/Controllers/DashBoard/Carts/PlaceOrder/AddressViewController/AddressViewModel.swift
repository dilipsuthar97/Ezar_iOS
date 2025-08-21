//
//  AddressViewModel.swift
//  Customer
//
//  Created by webwerks on 5/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class AddressViewModel: NSObject
{
    var product_id_list : [Any] = []
    var name : String = ""
    var address : String = ""
    var street : String = ""
    var postCode : String = ""
    var city : String = ""
    var state : String = ""
    var country : String = ""
    var contactNumber : String = ""
    var addressType : String = ""
    var instruction : String = "NA"
    var countryCode : String = ""

    var longitude  : String = ""  //         : Double = 0.00
    var latitude   : String = ""       // : Double = 0.00
    
    
    var totalPayable : String = "0.0"
    var deliveryCharges : Int = 0
    
    var shippingMethod : ShippingMethods?
    var shoppingBagItems : ShoppingBagItem?
    
    var countryName: String = ""
    var isDefaultAddress : Int = 0
    var isNewAddress : Int = 1
    var addressId : Int = 0
    var giftWrap : Int = 0

}
