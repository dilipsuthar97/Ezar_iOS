//
//  LoginRespose.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import ObjectMapper

class ShoppingBagResponse: BaseResponse {
    
    var data : ShoppingBagItem?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct ShoppingBagItem: Mappable {
    
    var broadcast_request_id                     : Int                    = 0
    var quote_id                                : String                    = ""
    var customer_id                             : String                    = ""
    var total_items                             : Int                       = 0
    var currency_symbol                         : String                    = ""
    var shoppingBagItemList                     : [ShoppingBagItemList]     = []
    var subtotal_formatted                      : String                    = "0.0"
    var subtotal_normal                         : Double                    = 0.0
    var subtotal_after_discount_formatted       : String                    = "0.0"
    var subtotal_after_discount_normal          : Double                    = 0.0
    var grand_total_formatted                   : String                    = "0.0"
    var grand_total_normal                      : Double                    = 0.00
    var discount_amount_formatted               : String                    = "0.0"
    var discount_amount_normal                  : Double                    = 0.0
    var tax_amount_formatted                    : String                    = "0.0"
    var tax_amount_normal                       : Double                    = 0.0
    var cart_request_status                     : CartRequestStatus?
    var gift_wrap_item_price                    : Double                    = 0.0
    var gift_wrap_total_normal                  : Double                    = 0.00
    var gift_wrap_total_formatted               : String                    = "0.0"
    var coupon_code                             : String                    = ""
    var coupon_applied                          : Int                       = 0
    var gift_wrap_grand_total_normal            : Double                    = 0.00
    var gift_wrap_grand_total_formatted         : String                    = "0.0"
    var vat_in_percent                          : Double                    = -1.00
    var DelegateCommission_formatted            : String                    = ""
    var DelegateCommission_normal               : Int                       = 0
    var total_style_charges_formatted           : String                    = "0.0"
    var total_style_charges_normal              : Double                    = 0.0
    
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        broadcast_request_id                <- map["broadcast_request_id"]
        quote_id                            <- map["quote_id"]
        customer_id                         <- map["customer_id"]
        total_items                         <- map["total_items"]
        currency_symbol                     <- map["currency_symbol"]
        shoppingBagItemList                 <- map["items"]
        subtotal_formatted                  <- map["subtotal.formatted"]
        subtotal_normal                     <- map["subtotal.normal"]
        subtotal_after_discount_formatted   <- map["subtotal_after_discount.formatted"]
        subtotal_after_discount_normal      <- map["subtotal_after_discount.normal"]
        grand_total_formatted               <- map["grand_total.formatted"]
        grand_total_normal                  <- map["grand_total.normal"]
        discount_amount_formatted           <- map["discount_amount.formatted"]
        discount_amount_normal              <- map["discount_amount.normal"]
        tax_amount_formatted                <- map["tax_amount.formatted"]
        tax_amount_normal                   <- map["tax_amount.normal"]
        cart_request_status                 <- map["request_status"]
        gift_wrap_item_price                <- map["gift_wrap_item_price"]
        gift_wrap_total_normal              <- map["gift_wrap_total.normal"]
        gift_wrap_total_formatted           <- map["gift_wrap_total.formatted"]
        coupon_code                         <- map["coupon_code"]
        coupon_applied                      <- map["coupon_applied"]
        gift_wrap_grand_total_normal        <- map["gift_wrap_grand_total.normal"]
        gift_wrap_grand_total_formatted     <- map["gift_wrap_grand_total.formatted"]
        vat_in_percent                      <- map["vat_in_percent"]
        DelegateCommission_formatted        <- map["delegate_commission.formatted"]
        DelegateCommission_normal           <- map["delegate_commission.normal"]
        
        total_style_charges_formatted <- map["total_style_charges.formatted"]
        total_style_charges_normal <- map["total_style_charges_norma.normall"]
        
    }
}

struct ShoppingBagItemList: Mappable
{
    var item_quote_id           : String                        = ""
    var is_favourite            : Int                           = 0
    var iProduct_id             : Int                           = 0
    var sProduct_id             : String                        = ""
    var title                   : String                        = ""
    var category_name           : String                        = ""
    var image                   : String                        = ""
    var qty                     : Int                           = 0
    var product_type            : String                        = ""
    var price_formatted         : String                        = ""
    var price_normal            : Double = 0.0
    var currency_symbol         : String                        = ""
    var valid_Message           : String                        = ""
    var valid_Status            : Int                           = 0
    var special_price_formatted : String                        = ""
    var special_price_normal     : Double = 0.0
    var per_off                 : String                        = ""
    var fabric_id               : String                        = ""
    var fabric_included         : String = ""
    var fabric_Detail           : FabricDetails?
    var measurement_id          : String                        = ""
    var styles                  : [ShoppingBagItemStyle]        = []
    var model_type              : String = ""
    var delivery_date           : String                        = ""
    var attributes_info         : [AttributesInfo]              = []
    var item_request_status     : ItemRequestStatus?
    var reward_points           : Int                           = 0
    var min_fabric_required     : String                        = ""
    var display_price_formatted : String                        = ""
    var display_price_normal        : Double = 0.0
    var quote_id                                : String                    = ""
    var style_charges : Double = 0.0
    var category_id      : String = ""
    var measurement_status : Int = 0
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        item_quote_id               <- map["item_quote_id"]
        is_favourite                <- map["is_favourite"]
        iProduct_id                 <- map["product_id"]
        sProduct_id                 <- map["product_id"]
        title                       <- map["title"]
        category_name               <- map["category_name"]
        image                       <- map["image"]
        qty                         <- map["qty"]
        product_type                <- map["product_type"]
        price_formatted             <- map["price.formatted"]
        price_normal                <- map["price.normal"]
        currency_symbol             <- map["currency_symbol"]
        valid_Message               <- map["valid.message"]
        valid_Status                <- map["valid.status"]
        special_price_formatted     <- map["special_price.formatted"]
        special_price_normal        <- map["special_price.normal"]
        per_off                     <- map["per_off"]
        fabric_id                   <- map["fabric_id"]
        fabric_included             <- map["fabric_included"]
        fabric_Detail               <- map["fabric_detail"]
        measurement_id              <- map["measurement_id"]
        styles                      <- map["styles"]
        model_type                  <- map["model_type"]
        delivery_date               <- map["delivery_date"]
        attributes_info             <- map["attributes_info"]
        item_request_status         <- map["request_status"]
        reward_points               <- map["reward_points"]
        min_fabric_required         <- map["min_fabric_required"]
        display_price_formatted     <- map["display_price.formatted"]
        display_price_normal        <- map["display_price.normal"]
        quote_id                    <- map["quote_id"]
        style_charges               <- map["style_charges"]
        category_id                 <- map["category_id"]
        measurement_status          <- map["measurement_status"]
    }
}

struct FabricDetails: Mappable
{
    var fabric_id       : String        = ""
    var fabric_offline  : Int           = 0
    var price           : String        = "0"
    var qty             : String        = "0"
    var total           : String        = "0"
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        fabric_id                   <- map["fabric_id"]
        fabric_offline              <- map["fabric_offline"]
        price                       <- map["price"]
        qty                         <- map["qty"]
        total                       <- map["total"]
    }
}

struct ShoppingBagItemStyle: Mappable
{
    var parent_id              : String        = "0"
    var child_id               : String        = "0"
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        parent_id                  <- map["parent_id"]
        child_id                   <- map["child_id"]
    }
}

struct AttributesInfo: Mappable
{
    var label           : String                        = ""
    var value           : String                        = ""
    var option_id       : Int                           = 0
    var option_value    : Int                           = 0
    var sOption_value    : String                        = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        label           <- map["label"]
        value           <- map["value"]
        option_id       <- map["option_id"]
        option_value    <- map["option_value"]
        sOption_value   <- map["option_value"]
    }
}

struct CartRequestStatus: Mappable
{
    var latitude            : String                        = "0.0"
    var longitude           : String                        = "0.0"
    var mobile_number       : String                        = ""
    var request_id          : Int                           = 0
    var status              : String                        = ""
    var request_instruction : RequestInstruction?
    var country_code       : String                        = ""
    var is_arrived         : String                        = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        latitude                <- map["latitude"]
        longitude               <- map["longitude"]
        mobile_number           <- map["mobile_number"]
        request_id              <- map["request_id"]
        status                  <- map["status"]
        request_instruction     <- map["request_instruction"]
        country_code            <- map["country_code"]
        is_arrived              <- map["is_arrived"]
    }
}

struct RequestInstruction : Mappable {
    var mobileNumber                      : String  = ""
    var instructions                      : String  = ""
    var location_name                     : String = ""
    var location_type                     : String = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        instructions              <- map["instructions"]
        location_name             <- map["location_name"]
        location_type            <- map["location_type"]
    }
}

struct ItemRequestStatus: Mappable
{
    var fabric          : String                        = ""
    var measurement     : String                        = ""
    var quote_item_id   : String                        = ""
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        fabric              <- map["fabric"]
        measurement         <- map["measurement"]
        quote_item_id       <- map["item_quote_id"]
    }
}



