//
//  SellerViewModel.swift
//  Customer
//
//  Created by webwerks on 5/2/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class AvailOptions : NSObject
{
    var subOptionModelArray : [SubOptionModel] = []
}

class SubOptionModel : NSObject
{
    var label : String = ""
    var value : String = ""
}

class SellerViewModel: NSObject
{
    let APIClient           : SellerAPIClient
    var vendorDetail        : VendorDetail?
    var vendor_id           : Int = 0
    var category_id         : Int = 0
    var store_id            : Int = 0
    var product_id          : Int = 0
    var is_promotion        : Int = 0
    var quotedId            : String = ""
    var item_quote_id       : String = ""
    var avlOptionArray      : [[String : String]] = []
    var attributesInfo      : [AttributesInfo] = []
    var customer_id         : Int = Profile.loadProfile()?.id ?? 0
    var productType         : String = LocalDataManager.getUserSelection()
    var fabric_offline      : Int = -1
    var qty                 : Int = 0
    var delivery_date       : String = ""

    var reviewList          = [ReviewsList]()
    var finalAvlArray       : Set = [NSMutableDictionary()]
    var reivewType          : String?
    var review_id           : Any?
    var upVote              : Int?
    var statusCode         : Int = 0
    var minFabricReq       : String = ""
    var type                : ReviewType = .Product
    var totalCartCount      : Int = 0
    
    init(apiClient: SellerAPIClient = SellerAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Vender Details
    func getVendorDetails(complete: @escaping isCompleted) {
        let params : NSMutableDictionary = [API_KEYS.vendor_id : vendor_id,API_KEYS.lang : COMMON_SETTING.lang,API_KEYS.customer_id : customer_id]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.SellerDetails(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let data = response.data {
                    self.vendorDetail = data
                    if let reviewlist = data.reviewRatings?.reviews?.list {
                        self.reviewList = reviewlist
                    }
                    complete()
                }
            })
        }
    }

    //Product Details
    func getProductDetails(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.product_id   : product_id,
                                            API_KEYS.category_id : category_id,
                                            API_KEYS.delivery_date : COMMON_SETTING.deliveryDate,
                                            API_KEYS.lang : COMMON_SETTING.lang,
                                            API_KEYS.is_promotion : is_promotion,
                                            API_KEYS.customer_id   : customer_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ProductDetails(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                self.statusCode = response.code ?? 0
                if let data = response.data
                {
                    self.vendorDetail = data
                    if let vendorId = Int(data.vendor_id){
                    self.vendor_id =  vendorId
                    }
                    if let reviewlist = data.reviewRatings?.reviews?.list
                    {
                        self.reviewList = reviewlist
                    }
                }
                 complete()
            })
        }
    }
    
    //Product Details
    func getReadyMadeProductDetails(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.product_id   : self.product_id,
                                            API_KEYS.product_type : LocalDataManager.getUserSelection(),
                                            API_KEYS.lang : COMMON_SETTING.lang,
                                            API_KEYS.is_promotion : is_promotion,
                                            API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ProductDetails(for: params, completionHandler: { (response) in
                self.statusCode = response.code ?? 0
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self.vendorDetail = data
                    self.createKeyValuePair()
                    self.checkEnableOptions()
                    if let reviewlist = data.reviewRatings?.reviews?.list
                    {
                        self.reviewList = reviewlist
                    }
//                    complete()
                }
                complete()
            })
        }
    }
    
    func createKeyValuePair()
    {
        for valueList in (self.vendorDetail?.avaliable_options)!
        {
            var key = ""
            var keykey = ""
            var value = ""
            var image = ""
            for dictionary in valueList.valueList
            {
                let dic : NSMutableDictionary = NSMutableDictionary()
                if key.isEmpty
                {
                    key = dictionary.value
                }
                else if keykey.isEmpty
                {
                    keykey = dictionary.value
                    image = dictionary.image
                }
                else
                {
                    value = dictionary.value
                    image = dictionary.image
                }
                if !(key.isEmpty) && !(keykey.isEmpty) && !(value.isEmpty)
                {
                    let mixKey = key+keykey
                    dic.addEntries(from: [mixKey : value])
                    dic.addEntries(from: [value : image])
                    finalAvlArray.insert(dic)
                }
                else if !(key.isEmpty) && !(keykey.isEmpty)
                {
                    dic.addEntries(from: [key : keykey])
                    dic.addEntries(from: [keykey : image])
                    finalAvlArray.insert(dic)
                }
            }
        }
    }
    
    func checkEnableOptions()
    {
        for (input, _) in (self.vendorDetail?.all_options.enumerated())!
        {
            for (index, _) in (self.vendorDetail?.all_options[input].options.enumerated())!
            {
                for valuelist in (self.vendorDetail?.avaliable_options)!
                {
                    for availableOptions in valuelist.valueList
                    {
                        if availableOptions.value == self.vendorDetail?.all_options[input].options[index].label
                        {
                            self.vendorDetail?.all_options[input].options[index].isDisable = false
                        }
                    }
                }
                
            }
        }
        //setValues()
        if self.attributesInfo.count > 0
        {
            self.previouslySelectedOptions()
        }
    }
    
    func previouslySelectedOptions()
    {
        for (input, _) in (self.vendorDetail?.all_options.enumerated())!
        {
            for (index, _) in (self.vendorDetail?.all_options[input].options.enumerated())!
            {
                for attributesInfo in self.attributesInfo
                {
                    if attributesInfo.value == self.vendorDetail?.all_options[input].options[index].label
                    {
                        self.vendorDetail?.all_options[input].options[index].isSelected = true
                        break
                    }
                }
            }
        }
    }
    
    func addToCart(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id: Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.product_id: self.product_id,
                                            API_KEYS.category_name: self.vendorDetail?.categories ?? "",
                                            API_KEYS.style: "",
                                            API_KEYS.qty: COMMON_SETTING.quantity,
                                            API_KEYS.price: self.vendorDetail?.price_incl_tax ?? "",
                                            API_KEYS.special_price: self.vendorDetail?.special_price ?? "",
                                            API_KEYS.delivery_date: COMMON_SETTING.deliveryDate,
                                            API_KEYS.item_quote_id: item_quote_id,
                                            API_KEYS.reward_points: self.vendorDetail?.reward_points ?? "",
                                            API_KEYS.category_id: self.category_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.AddToCart(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            })
        }
    }
    
    func addToCartReadyMadeProduct(complete: @escaping isCompleted)
    {
        let profile = Profile.loadProfile()
        let custmerID = profile?.id ?? 0
        let params : NSMutableDictionary = [API_KEYS.product_id:self.product_id,
                                            API_KEYS.product_type:LocalDataManager.getUserSelection(),
                                            API_KEYS.qty:COMMON_SETTING.quantity == 0 ? 1 : COMMON_SETTING.quantity,
                                            API_KEYS.customer_id:custmerID,
                                            API_KEYS.category_name:self.vendorDetail?.categories ?? "",
                                            API_KEYS.quote_id:self.quotedId,
                                            API_KEYS.reward_points: self.vendorDetail?.reward_points ?? "",
                                            API_KEYS.category_id: self.category_id]
        
        if self.avlOptionArray.count > 0
        {
            for dictionary in self.avlOptionArray
            {
                params.addEntries(from: dictionary)
            }
        }
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.AddToCartForReadymade(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                APP_DELEGATE.updateBadgeCount(count: response.data?.cart_count ?? 0)
                self.totalCartCount = response.data?.cart_count ?? 0
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            })
        }
    }
    
    func updateReadyMadeProduct(complete: @escaping isCompleted)
    {
        let profile = Profile.loadProfile()
        let custmerID = profile?.id ?? 0
        let params : NSMutableDictionary = [API_KEYS.product_id:self.product_id,
                                            API_KEYS.product_type:LocalDataManager.getUserSelection(),
                                            API_KEYS.qty:COMMON_SETTING.quantity == 0 ? 1 : COMMON_SETTING.quantity,
                                            API_KEYS.customer_id:custmerID,
                                            API_KEYS.quote_id:self.quotedId,
                                            API_KEYS.item_quote_id:self.item_quote_id,
                                            API_KEYS.reward_points: self.vendorDetail?.reward_points ?? "",
                                            API_KEYS.category_id: self.category_id]
        
        
        if self.avlOptionArray.count > 0
        {
            params.removeAllObjects()
            for dictionary in self.avlOptionArray
            {
                params.addEntries(from: dictionary)
            }
            params.addEntries(from: [API_KEYS.product_id:self.product_id,
                                     API_KEYS.product_type:LocalDataManager.getUserSelection(),
                                     API_KEYS.qty:COMMON_SETTING.quantity == 0 ? 1 : COMMON_SETTING.quantity,
                                     API_KEYS.customer_id:custmerID,
                                     API_KEYS.quote_id:self.quotedId,
                                     API_KEYS.item_quote_id:self.item_quote_id])
        }
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.UpdateCart(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            })
        }
    }
    
    func getFabricDetails(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.category_id : category_id,
                                            API_KEYS.product_id : product_id,
                                            API_KEYS.quote_id : quotedId,
                                            API_KEYS.item_quote_id : item_quote_id,
                                            API_KEYS.customer_id : customer_id,
                                            API_KEYS.product_type : productType,API_KEYS.lang :COMMON_SETTING.lang]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.FabricDetails(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self.vendorDetail = data
                    if let reviewlist = data.reviewRatings?.reviews?.list
                    {
                        self.reviewList = reviewlist
                    }
                    complete()
                }
            })
        }
    }
    
    func applyFabricOffline(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.product_id : self.product_id,
                                            API_KEYS.quote_id : self.quotedId,
                                            API_KEYS.item_quote_id : self.item_quote_id,
                                            API_KEYS.customer_id : customer_id,
                                            API_KEYS.product_type : LocalDataManager.getUserSelection(),
                                            API_KEYS.fabric_offline : self.fabric_offline,
                                            API_KEYS.qty : self.qty,
                                            API_KEYS.delivery_date : self.delivery_date,
                                            API_KEYS.reward_points : self.vendorDetail?.reward_points ?? ""]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ApplyFabricOffline(for: params, completionHandler: { (response) in
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            })
        }
    }
    
    func addToWishlist(_ params : NSMutableDictionary, complete: @escaping isCompleted)
    {
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.AddToWishlist(for: params) { (response) in
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            }
        }
    }
    
    func removeFromWishList(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.item_id : product_id,
                                            API_KEYS.type : type.rawValue]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.RemoveFromWishList(for: params) { (response) in
                IProgessHUD.dismiss()
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            }
        }
    }
    
    func setReviewLikeDislike(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.review_id : self.review_id ?? "",
                                            API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.review_type : self.reivewType ?? "",
                                            API_KEYS.up_vote : self.upVote ?? -1]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ReviewLikeDislike(for: params) { (response) in
                IProgessHUD.dismiss()
                
                if let message = response.message{
                    INotifications.show(message: message)
                }
                if let status = response.code, status == 200{
                    complete()
                }
            }
        }
    }
}

