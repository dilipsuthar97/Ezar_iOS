//
//  OrderResponse.swift
//  Customer
//
//  Created by webwerks on 9/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderDetailResponse: BaseResponse
{
    var data : orderDetails?

    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map ["data"]
    }
}

struct orderDetails: Mappable
{
    var order_id            : Int       = 0
    var order_increment_id  : Int       = 0
    var status              : String    = ""
    var status_label        : String    = ""
    var no_of_products      : Int       = 0
    var total               : Int        = 0
    var currency_symbol     : String    = ""
    var payment_mode        : String    = ""
    var description         : String    = ""
    var delivery_date       : String    = ""
    var created_at          : String    = ""
    var updated_at          : String    = ""
    var address                       : address?
    var discount_amount_formatted      : String    = ""
    var discount_amount_normal         : Double                    = 0.00
    var gift_wrap_total_formatted      : String    = ""
    var gift_wrap_total_normal         : Double                    = 0.00
    var grand_total_formatted          : String    = ""
    var grand_total_normal             : Double                    = 0.00
    var items                          : [ItemList] = []
    var reward_amount_discount_formatted  : String    = ""
    var reward_amount_discount_normal     : Double                    = 0.00
    var reward_credited                 : Int       = 0
    var reward_used                     : Int       = 0
    var ship_and_pay_info               : ShippingPaymentInfo?

    var shipping_amount_formatted       : String    = ""
    var shipping_amount_normal          : Double    = 0.00
    var state                           : String    = "" 
    var subtotal_formatted              : String    = ""
    var subtotal_normal                 : Double    = 0.00
    var tax_amount_formatted            : String    = ""
    var tax_amount_normal               : Double = 0.00
    var supplier_type                   : String    = ""
    var review_format                   : ReviewFormat?
    var isAllReturned                   : Bool = false
    var delegate_id                     : Int  = 0
    var delegateCommission_formatted    : String  = ""
    var delegateCommission_normal       : Int  = 0
    var vat_in_percent                 : Int  = 0
    
    init?(map: Map) {
    }

    // Mappable
    mutating func mapping(map: Map) {

        order_id            <- map["order_id"]
        order_increment_id  <- map["order_increment_id"]
        status              <- map["status"]
        status_label        <- map["status_label"]
        no_of_products      <- map["no_of_products"]
        total               <- map["total"]
        currency_symbol     <- map["currency_symbol"]
        payment_mode        <- map["payment_mode"]
        description         <- map["description"]
        delivery_date       <- map["delivery_date"]
        created_at          <- map["created_at"]
        updated_at          <- map["updated_at"]
        address                        <- map["address"]
        discount_amount_formatted      <- map["discount_amount.formatted"]
        discount_amount_normal         <- map["discount_amount.normal"]
        gift_wrap_total_formatted      <- map["gift_wrap_total.formatted"]
        gift_wrap_total_normal         <- map["gift_wrap_total.normal"]
        grand_total_formatted          <- map["grand_total.formatted"]
        grand_total_normal             <- map["grand_total.normal"]
        items                          <- map["items"]
        reward_amount_discount_formatted    <- map["reward_amount_discount.formatted"]
        reward_amount_discount_normal       <- map["reward_amount_discount.normal"]
        reward_credited                     <- map["reward_credited"]
        reward_used                         <- map["reward_used"]
        ship_and_pay_info                   <- map["ship_and_pay_info"]
        shipping_amount_formatted           <- map["shipping_amount.formatted"]
        shipping_amount_normal              <- map["shipping_amount.normal"]
        state                               <- map["state"]
        subtotal_formatted                  <- map["subtotal.formatted"]
        subtotal_normal                     <- map["subtotal.normal"]
        tax_amount_formatted                <- map["tax_amount.formatted"]
        tax_amount_normal                   <- map["tax_amount.normal"]
        supplier_type                   <- map["supplier_type"]
        review_format                   <- map["review_format"]
        delegate_id                     <- map["delegate_id"]
        delegateCommission_formatted        <- map["delegate_commission_amount.formatted"]
        delegateCommission_normal           <- map["delegate_commission_amount.normal"]
        vat_in_percent <- map["vat_in_percent"]
   }
}

struct address : Mappable {
    var billing                  : AddressDetails?
    var shipping                 : AddressDetails?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        billing                 <- map["billing"]
        shipping                <- map["shipping"]
    }
}

struct AddressDetails: Mappable {
    var street              : String = ""
    var city                : String = ""
    var telephone           : String = ""
    var latitude            : String = ""
    var longitude           : String = ""
    var is_default          : Int = 0
    var country_id        : String = ""
    var delivery_instruction   : String = ""
    var location_type       : String = ""
    var firstname           : String = ""
    var postcode            : String = ""
    var region              : String = ""
    var country            : String = ""
    var email              : String = ""
    var location_name      : String = ""

    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        street                 <- map["street"]
        city                   <- map["city"]
        telephone              <- map["telephone"]
        latitude               <- map["latitude"]
        longitude              <- map["longitude"]
        is_default             <- map["default"]
        country_id             <- map["country_id"]
        delivery_instruction   <- map["delivery_instruction"]
        location_type          <- map["location_type"]
        firstname             <- map["firstname"]
        postcode              <- map["postcode"]
        region                <- map["region"]
        country               <- map["country"]
        email                 <- map["email"]
        location_name         <- map["location_name"]

    }
}

struct ShippingPaymentInfo : Mappable {
    var payment                  : ShippingPaymentDetail?
    var shipping                 : ShippingPaymentDetail?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        payment                 <- map["payment"]
        shipping                <- map["shipping"]
    }
}


struct ShippingPaymentDetail: Mappable {
    
    var amount_paid            : String               = ""
    var instructions           : String               = ""
    var title                  : String               = ""
    var method                 : String               = ""
    var amount                 : String               = ""
    var description            : String               = ""

    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        amount_paid                 <- map["amount_paid"]
        instructions                <- map["instructions"]
        method                      <- map["method"]
        title                       <- map["title"]
        amount                      <- map["amount"]
        description                 <- map["description"]
    }
}

struct ItemList: Mappable {
    var extra_info              : extraInfo?
    var final_price             : Int = 0
    var image                   : String = ""
    var magento_product_type    : String = ""
    var name                    : String = ""
    var order_item_id           : Int = 0
    var original_price          : Int = 0
    var per_off                 : Double = 0.0
    var product_id              : Int = 0
    var qty_canceled            : Int = 0
    var qty_invoiced            : Int = 0
    var qty_ordered             : Int = 0
    var qty_refunded            : Int = 0
    var qty_shipped             : Int = 0
    var rating_and_reviews      : RatingAndReviews?
    var review_type             : String = ""
    var row_total               : Int = 0
    var return_req_qty          : Int = 0
    var return_req_send         : String = ""
    var sku                     : String = ""
    var isSeleced               : Bool = false
    var diff_shipped_refund     : Int = -1
    var returnQty               : Int = 0
    var style_selection : [Style_selection]?
    var measurements_info : Measurements_info?
    var vendor_id            : String = ""
    
    var order_review         : Int?
    var vendor_review         : Int?
    var delegate_review         : Int?
    //000 001 010 011 100 101 110 111 
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        extra_info               <- map["extra_info"]
        final_price              <- map["final_price"]
        image                    <- map["image"]
        magento_product_type     <- map["magento_product_type"]
        name                     <- map["name"]
        order_item_id            <- map["order_item_id"]
        original_price           <- map["original_price"]
        per_off                  <- map["per_off"]
        product_id               <- map["product_id"]
        qty_canceled             <- map["qty_canceled"]
        qty_invoiced             <- map["qty_invoiced"]
        qty_ordered              <- map["qty_ordered"]
        qty_refunded             <- map["qty_refunded"]
        qty_shipped              <- map["qty_shipped"]
        rating_and_reviews       <- map["rating_and_reviews"]
        review_type              <- map["review_type"]
        row_total                <- map["row_total"]
        sku                      <- map["sku"]
        diff_shipped_refund      = qty_shipped - qty_refunded
        returnQty                = qty_shipped - qty_refunded
        style_selection          <- map["style_selection"]
        measurements_info        <- map["measurements_info"]
        vendor_id                <- map["vendor_id"]
        order_review             <- map["order_review"]
        vendor_review            <- map["vendor_review"]
        delegate_review          <- map["delegate_review"]
        return_req_qty            <- map["return_req_qty"]
        return_req_send          <- map["return_req_send"]
    }
}

struct extraInfo: Mappable {
    
    var additional_options_measurement      : [String]    = []
    var additional_options_style_selection  : [String]    = []
    var attributes_info             : [AttributesInfo]              = []
    var simple_name                 : String       = ""
    var simple_sku                  : String       = ""
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        additional_options_measurement             <- map["additional_options.measurements"]
        additional_options_style_selection             <- map["additional_options.style_selection"]
        attributes_info                <- map["attributes_info"]
        simple_name                    <- map["simple_name"]
        simple_sku                     <- map["simple_sku"]
    }
}
struct Style_selection : Mappable {
    var title : String?
    var value : String?
    var image : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title <- map["title"]
        value <- map["value"]
        image <- map["image"]
    }
    
}
struct Measurements_info : Mappable {
    var measurement_type : String = ""
    var measurement_id : String = ""
    var model_type : String = ""
    var name : String = ""
    var height : String?
    var weight : String?
    var collar_size : String?
    var options : [Options]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        measurement_type <- map["measurement_type"]
        measurement_id <- map["measurement_id"]
        model_type <- map["model_type"]
        name <- map["name"]
        height <- map["height"]
        weight <- map["weight"]
        collar_size <- map["collar_size"]
        options <- map["options"]
    }
    
}
struct Options : Mappable {
    var title : String = ""
    var value : String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title <- map["title"]
        value <- map["value"]
    }
    
}
